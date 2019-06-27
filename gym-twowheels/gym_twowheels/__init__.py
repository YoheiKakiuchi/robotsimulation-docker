from gym.envs.registration import register

register(
    id='twowheels-v0',
    entry_point='gym_twowheels.envs:TwowheelsEnv',
    max_episode_steps = 2400,
    reward_threshold  = 2395.0,
)

register(
    id='twowheelsros-v0',
    entry_point='gym_twowheels.envs:RosEnv',
    max_episode_steps = 2400,
    reward_threshold  = 2395.0,
)
