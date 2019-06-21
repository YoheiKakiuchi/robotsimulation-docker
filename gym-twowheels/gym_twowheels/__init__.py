from gym.envs.registration import register

register(
    id='twowheels-v0',
    entry_point='gym_twowheels.envs:TwowheelsEnv',
    max_episode_steps = 600,
    reward_threshold  = 595.0,
)
