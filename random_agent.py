import argparse
import sys

import gym
from gym import wrappers, logger

import gym_twowheels

class RandomAgent(object):
    """The world's simplest agent!"""
    def __init__(self, action_space):
        self.action_space = action_space

    def act(self, observation, reward, done):
        #return self.action_space.sample()
        aaa = 0
        #aaa = aaa + (-728.5774 * observation[0]) # th
        #aaa = aaa + (-7.7460   * observation[1]) # d_th
        #aaa = aaa + (-253.9665 * observation[2]) # p
        #aaa = aaa + (-12.7578  * observation[3]) # d_p
        aaa = aaa + (-1.0981e+03 * observation[0]) # th
        aaa = aaa + (-2.6417e+02 * observation[1]) # d_th
        aaa = aaa + (-4.4721e+00 * (observation[1] + observation[3])) # d_th + d_p
        aaa = - aaa
        if aaa > 400:
            aaa = 400
        if aaa < -400:
            aaa = -400
        ret = self.action_space.sample()
        ret[0] = aaa
        return ret

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=None)
    parser.add_argument('env_id', nargs='?', default='twowheels-v0',
                        help='Select the environment to run')
    args = parser.parse_args()

    # You can set the level to logger.DEBUG or logger.WARN if you
    # want to change the amount of output.
    logger.set_level(logger.INFO)

    env = gym.make(args.env_id)

    # You provide the directory to write to (can be an existing
    # directory, including one with existing data -- all monitor files
    # will be namespaced). You can also dump to a tempdir if you'd
    # like: tempfile.mkdtemp().
    outdir = '/tmp/random-agent-results'
    env = wrappers.Monitor(env, directory=outdir, force=True)
    env.seed(0)
    agent = RandomAgent(env.action_space)

    episode_count = 100
    reward = 0
    done = False

    for i in range(episode_count):
        ob = env.reset()
        #print 'reset', ob
        while True:
            action = agent.act(ob, reward, done)
            ob, reward, done, _ = env.step(action)
            #print action, ob
            if done:
                print 'DONE'
                break
            # Note there's no env.render() here. But the environment still can open window and
            # render if asked by env.monitor: it calls env.render('rgb_array') to record video.
            # Video is not recorded every episode, see capped_cubic_video_schedule for details.

    # Close the env and write monitor result info to disk
    env.close()
