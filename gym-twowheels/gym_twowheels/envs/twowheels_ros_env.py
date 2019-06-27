# -*- coding: utf-8 -*-
import gym
from gym import error, spaces, utils, logger
from gym.utils import seeding

import math
import numpy as np

####
import subprocess
import rospy

import time

from aizuspider_description.srv import (
    Control,
    )
from std_srvs.srv import (
    Empty,
    )

class RosEnv(gym.Env):
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second' : 50
    }
    def __init__(self):
        ####
        rospy.init_node('rosenv_client', anonymous=True)

        ## rospy.wait_for_service('/chainerrl/control2'%(name))
        self.ctrl_srv = rospy.ServiceProxy('/chainerrl/control2', Control, persistent=True)
        self.cho_srv  = rospy.ServiceProxy('/choreonoid/reset_simulation', Empty, persistent=True)
        self.choreonoid_proc = None
        ####

        # Angle at which to fail the episode
        self.theta_threshold =  30  *  math.pi / 180
        #self.phi_threshold   = 720 *  math.pi / 180
        self.phi_threshold   = 2160 *  math.pi / 180

        # Angle limit set to 2 * theta_threshold_radians so failing observation is still within bounds
        high = np.array([
            self.theta_threshold * 2,
            np.finfo(np.float32).max,
            self.phi_threshold   * 2,
            np.finfo(np.float32).max])

        ## continuous
        act = np.array([100])
        self.action_space = spaces.Box(-act, act, dtype=np.float32)
        ## discrete
        #self.action_space = spaces.Discrete(2) -tq, +tq
        #self.action_space = spaces.Discrete(3) ## -tq, 0, +tq

        self.observation_space = spaces.Box(-high, high, dtype=np.float32)

        self.seed()
        self.viewer = None
        self.state  = None

        self.steps_beyond_done = None

    def step(self, action): # actionを実行し、結果を返す
        #assert self.action_space.contains(action), "%r (%s) invalid"%(action, type(action))
        if not self.action_space.contains(action):
            print "%r (%s) invalid"%(action, type(action))
        ###
        #print ('->')
        res = self.ctrl_srv(state=[action[0]])
        #print ('<-')
        #print(res)
        theta     = res.action[0]
        theta_dot = res.action[1]
        phi       = res.action[2]
        phi_dot   = res.action[3]

        self.state = (theta, theta_dot, phi, phi_dot)

        done =     phi < -self.phi_threshold \
                or phi >  self.phi_threshold \
                or theta < -self.theta_threshold \
                or theta >  self.theta_threshold
        done = bool(done)

        if not done:
            reward = 1.0
        elif self.steps_beyond_done is None:
            # Pole just fell!
            print('fail %6.1f %6.1f', phi*180/math.pi, theta*180/math.pi)
            self.steps_beyond_done = 0
            reward = 1.0
        else:
            if self.steps_beyond_done == 0:
                logger.warn("You are calling 'step()' even though this environment has already returned done = True. You should always call 'reset()' once you receive 'done = True' -- any further steps are undefined behavior.")
            self.steps_beyond_done += 1
            reward = 0.0

        reward = reward - math.fabs(self.state[0]) /  5.0
        reward = reward - math.fabs(self.state[1] + self.state[3]) / 10.0
        ## state, reward, done    , {}
        ## [4]  ,       ,  T or F , nothing
        return np.array(self.state), reward, done, {}

    def reset(self): # 状態を初期化し、初期の観測値を返す
        print('reset')
        self.state = self.np_random.uniform(low=-0.3, high=0.3, size=(4,))
        self.steps_beyond_done = None
        res = self.ctrl_srv(state=[])
        time.sleep(0.2)
        res = self.cho_srv()
        ###
        time.sleep(0.2)
        self.ctrl_srv = rospy.ServiceProxy('/chainerrl/control2', Control)

        ##print('wait..........')
        self.ctrl_srv.wait_for_service(5)

        ##print('call..........')
        try:
            res = self.ctrl_srv(state=[0])
        except:
            print('except')
            res = self.ctrl_srv(state=[0])
            pass

        self.state = (res.action[0],
                      res.action[1],
                      res.action[2],
                      res.action[3])
        ##print('ret..........')
        return np.array(self.state)

    def render(self, mode='human', close=False): # 環境を可視化する
        ###
        return True

    #def close(self): # 環境を閉じて後処理をする
    #    if self.viewer:
    #        self.viewer.close()
    #        self.viewer = None

    def seed(self, seed=None): # ランダムシードを固定する
        self.np_random, seed = seeding.np_random(seed)
        return [seed]
