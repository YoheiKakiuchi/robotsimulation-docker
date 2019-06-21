# -*- coding: utf-8 -*-
import gym
from gym import error, spaces, utils, logger
from gym.utils import seeding

import math
import numpy as np

class TwowheelsEnv(gym.Env):
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second' : 50
    }
    def __init__(self):

        self.gravity = 9.8
        self.tau = 0.02  # seconds between state updates
        self.kinematics_integrator = 'euler'

        self.mass_body     = 40
        self.mass_wheel    =  4
        self.inertia_body  = 10
        self.inertia_wheel =  1
        self.radius_wheel  = 0.2
        self.length_pole   = 0.9

        # Angle at which to fail the episode
        self.theta_threshold = 25  *  math.pi / 180
        self.phi_threshold   = 360 *  math.pi / 180

        # Angle limit set to 2 * theta_threshold_radians so failing observation is still within bounds
        high = np.array([
            self.theta_threshold * 2,
            np.finfo(np.float32).max,
            self.phi_threshold   * 2,
            np.finfo(np.float32).max])

        ## continuous
        act = np.array([40])
        self.action_space = spaces.Box(-act, act, dtype=np.float32)
        ## discrete
        #self.action_space = spaces.Discrete(2) -tq, +tq
        #self.action_space = spaces.Discrete(3) ## -tq, 0, +tq

        self.observation_space = spaces.Box(-high, high, dtype=np.float32)

        self.seed()
        self.viewer = None
        self.state = None

        self.steps_beyond_done = None

    def step(self, action): # actionを実行し、結果を返す
        #assert self.action_space.contains(action), "%r (%s) invalid"%(action, type(action))
        if not self.action_space.contains(action):
            print "%r (%s) invalid"%(action, type(action))

        state = self.state
        theta, theta_dot, phi, phi_dot = state
        #print action
        #print state
        ###
        ### continuous
        u_torque = action[0]

        ### discrete
        # u_torque = 0
        # if action == 0:
        #     u_torque = -30
        # elif action == 1:
        #     ## do nothing
        #     pass
        # else:
        #    u_torque = 30

        ##force = self.force_mag if action==1 else -self.force_mag
        cos_the = math.cos(theta)
        sin_the = math.sin(theta)

        aaa = self.radius_wheel * self.radius_wheel * (self.mass_body + self.mass_wheel) + self.inertia_wheel
        bbb = self.mass_body * self.radius_wheel * self.length_pole
        ccc = self.mass_body * self.length_pole * self.length_pole + self.inertia_body
        ddd = self.mass_body * self.gravity * self.length_pole * theta
        temp = 1.0 / (aaa * ccc - bbb * bbb)

        theta_dotdot = temp * ( aaa * ddd - (aaa + bbb) * u_torque )
        phi_dotdot = temp * ( -(aaa + bbb)*ddd + (aaa + 2 *bbb + ccc) * u_torque )

        if self.kinematics_integrator == 'euler':
            phi     = phi     + self.tau * phi_dot
            phi_dot = phi_dot + self.tau * phi_dotdot
            theta     = theta     + self.tau * theta_dot
            theta_dot = theta_dot + self.tau * theta_dotdot
        else: # semi-implicit euler
            phi_dot = phi_dot + self.tau * phi_dotdot
            phi     = phi     + self.tau * phi_dot
            theta_dot = theta_dot + self.tau * theta_dotdot
            theta     = theta     + self.tau * theta_dot

        self.state = (theta, theta_dot, phi, phi_dot)

        done =  phi < -self.phi_threshold   \
                or phi > self.phi_threshold \
                or theta < -self.theta_threshold \
                or theta > self.theta_threshold
        done = bool(done)

        if not done:
            reward = 1.0
        elif self.steps_beyond_done is None:
            # Pole just fell!
            self.steps_beyond_done = 0
            reward = 1.0
        else:
            if self.steps_beyond_done == 0:
                logger.warn("You are calling 'step()' even though this environment has already returned done = True. You should always call 'reset()' once you receive 'done = True' -- any further steps are undefined behavior.")
            self.steps_beyond_done += 1
            reward = 0.0

        reward = reward - math.fabs(self.state[0]) /  5.0
        reward = reward - math.fabs(self.state[2]) / 10.0
        ## state, reward, done    , {}
        ## [4]  ,       ,  T or F , nothing
        return np.array(self.state), reward, done, {}

    def reset(self): # 状態を初期化し、初期の観測値を返す
        self.state = self.np_random.uniform(low=-0.05, high=0.05, size=(4,))
        self.steps_beyond_done = None
        return np.array(self.state)

    def render(self, mode='human', close=False): # 環境を可視化する
        screen_width  = 600
        screen_height = 400

        #world_width = 2.2 * (2 * self.phi_threshold * self.radius_wheel)
        world_width = 2.2
        # world_width = self.x_threshold * 2
        scale       = screen_width / world_width

        carty     = 100 # TOP OF CART
        polewidth = 10.0
        polelen  = scale * (self.length_pole)
        wheel_r  = scale * (self.radius_wheel)
        body_r   = wheel_r * math.sqrt(self.mass_body/self.mass_wheel)

        if self.viewer is None:
            from gym.envs.classic_control import rendering
            self.viewer = rendering.Viewer(screen_width, screen_height)

            ### cart
            #cart = rendering.FilledPolygon([(l,b), (l,t), (r,t), (r,b)])
            cart = rendering.make_circle(wheel_r)
            ## cat.set_color
            cart.set_color(.8, .2, .2)
            self.carttrans = rendering.Transform()
            cart.add_attr(self.carttrans)
            ##
            self.viewer.add_geom(cart)

            ### pole
            l,r,t,b = -polewidth/2, polewidth/2, polelen, 0
            pole = rendering.FilledPolygon([(l,b), (l,t), (r,t), (r,b)])
            pole.set_color(.2, .2, .2)
            self.poletrans = rendering.Transform(translation=(0, 0))
            pole.add_attr(self.poletrans)
            pole.add_attr(self.carttrans)

            ### obj
            obj = rendering.make_circle(body_r)
            obj.set_color(.2, .2, .8)
            self.objtrans = rendering.Transform(translation=(0, polelen))
            obj.add_attr(self.objtrans)
            obj.add_attr(self.poletrans)
            obj.add_attr(self.carttrans)

            self.viewer.add_geom(obj)
            self.viewer.add_geom(pole)

            ### axle
            self.axle = rendering.make_circle(polewidth/2)
            self.axle_offset = rendering.Transform(translation=(0, -wheel_r*0.85))
            self.axletrans   = rendering.Transform(translation=(0, 0))
            self.axle.add_attr(self.axle_offset)
            self.axle.add_attr(self.axletrans)
            self.axle.add_attr(self.carttrans)
            self.axle.set_color(.8,.8,.8)
            self.viewer.add_geom(self.axle)

            ## line
            self.track = rendering.Line((0, carty - wheel_r), (screen_width, carty - wheel_r))
            self.track.set_color(0,0,0)
            self.viewer.add_geom(self.track)

            self._pole_geom = pole

        if self.state is None: return None

        # Edit the pole polygon vertex
        pole = self._pole_geom
        l,r,t,b = -polewidth/2, polewidth/2, polelen, 0
        pole.v = [(l,b), (l,t), (r,t), (r,b)]

        the = self.state[0]
        rot = self.state[0] + self.state[1]
        x_pos = 2 * self.radius_wheel * rot
        cartx = x_pos * scale + screen_width / 2.0 # MIDDLE OF CART

        self.carttrans.set_translation(cartx, carty)
        self.poletrans.set_rotation(-the)
        self.axletrans.set_rotation(-rot)

        return self.viewer.render(return_rgb_array = mode=='rgb_array')

    def close(self): # 環境を閉じて後処理をする
        if self.viewer:
            self.viewer.close()
            self.viewer = None

    def seed(self, seed=None): # ランダムシードを固定する
        self.np_random, seed = seeding.np_random(seed)
        return [seed]
