#!/usr/bin/env python
# pylint: disable=W0621
import numpy as np
import gym

class RandomAgent(object):
    """The world's simplest agent!"""
    def __init__(self, action_space):
        self.action_space = action_space
        self.reward_sum = 0
        self.rewards = []

    def new_episode(self):
        self.rewards.append(self.reward_sum)
        self.reward_sum = 0

    def act(self, observation, reward, done):
        self.reward_sum += reward
        return self.action_space.sample()

if __name__ == '__main__':
    env = gym.make('CartPole-v0')
    env.seed(0)
    agent = RandomAgent(env.action_space)

    episode_count = 10000
    reward = 0
    done = False

    for i in range(episode_count):
        ob = env.reset()
        agent.new_episode()
        while True:
            action = agent.act(ob, reward, done)
            ob, reward, done, _ = env.step(action)
            # env.render()
            if done:
                # print('reward sum', agent.reward_sum)
                break

    print(np.mean(agent.rewards))
    env.close()


# average return: 22.2413
