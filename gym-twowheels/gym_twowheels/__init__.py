from gym.envs.registration import register

register(
    id='twowheels-v0',
    entry_point='gym_twowheels.envs:TwowheelsEnv',
    max_episode_steps = 200,
    reward_threshold  = 195.0,
)
