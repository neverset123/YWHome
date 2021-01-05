---
layout:     post
title:      reinforcement learning
subtitle:   
date:       2021-01-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

## TF Agents
TF agents is a library to run different reinforced learning frameworks based on tensorflow. Official tutorial is here: https://github.com/tensorflow/agents/tree/master/docs/tutorials.
Available agents are: DQN, REINFORCE, DDPG, TD3, PPO and SAC

## example
there are lots of openAL environments available: https://gym.openai.com/envs/#classic_control. We take CartPole for example

        !pip install tensorflow==2.2.0
        !pip install tf-agents
        from __future__ import absolute_import, division, print_function
        import base64
        import IPython
        import matplotlib
        import matplotlib.pyplot as plt
        import numpy as np
        import tensorflow as tf
        import tf_agents

        env = tf_agents.environments.suite_gym.load('CartPole-v1')
        #converts the numpy arrays used for state observations, actions and rewards into TensorFlow tensors
        env = tf_agents.environments.tf_py_environment.TFPyEnvironment(env)

        #define q network for DQN agent
        q_net = tf_agents.networks.q_network.QNetwork(env.observation_spec(), env.action_spec())
        train_step_counter = tf.Variable(0)

        #define agent
        agent = tf_agents.agents.dqn.dqn_agent.DqnAgent(env.time_step_spec(),
                                                        env.action_spec(),
                                                        q_network=q_net,
                                                        optimizer=tf.compat.v1.train.AdamOptimizer(learning_rate=0.001),
                                                        td_errors_loss_fn=tf_agents.utils.common.element_wise_squared_loss,
                                                        train_step_counter=train_step_counter)

        agent.initialize()

        replay_buffer = tf_agents.replay_buffers.tf_uniform_replay_buffer.TFUniformReplayBuffer(data_spec=agent.collect_data_spec,                                                              batch_size=env.batch_size,                                                                        max_length=100000)
                                                                                        
        #Helper Methods: terate over the environment for a number of episodes, applying the policy to choose what actions to follow and return the average cumulative reward in these episodes
        def compute_avg_return(environment, policy, num_episodes=10):
                total_return = 0.0
                for _ in range(num_episodes):

                        time_step = environment.reset()
                        episode_return = 0.0

                        while not time_step.is_last():
                        action_step = policy.action(time_step)
                        time_step = environment.step(action_step.action)
                        episode_return += time_step.reward
                        total_return += episode_return

                avg_return = total_return / num_episodes
                return avg_return.numpy()[0]

        #collect and store data in buffer
        def collect_step(environment, policy, buffer):
                time_step = environment.current_time_step()
                action_step = policy.action(time_step)
                next_time_step = environment.step(action_step.action)
                traj = tf_agents.trajectories.trajectory.from_transition(time_step, action_step, next_time_step)

                # Add trajectory to the replay buffer
                buffer.add_batch(traj)

        # Evaluate the agent's policy once before training.
        avg_return = compute_avg_return(env, agent.policy, 5)
        returns = [avg_return]

        #train agent
        collect_steps_per_iteration = 1
        batch_size = 64
        dataset = replay_buffer.as_dataset(num_parallel_calls=3, 
                                        sample_batch_size=batch_size, 
                                        num_steps=2).prefetch(3)
        iterator = iter(dataset)
        num_iterations = 10000
        env.reset()

        for _ in range(batch_size):
        collect_step(env, agent.policy, replay_buffer)

        for _ in range(num_iterations):
        # Collect a few steps using collect_policy and save to the replay buffer.
        for _ in range(collect_steps_per_iteration):
                collect_step(env, agent.collect_policy, replay_buffer)

        # Sample a batch of data from the buffer and update the agent's network.
        experience, unused_info = next(iterator)
        train_loss = agent.train(experience).loss

        step = agent.train_step_counter.numpy()

        # Print loss every 200 steps.
        if step % 200 == 0:
                print('step = {0}: loss = {1}'.format(step, train_loss))

        # Evaluate agent's performance every 1000 steps.
        if step % 1000 == 0:
                avg_return = compute_avg_return(env, agent.policy, 5)
                print('step = {0}: Average Return = {1}'.format(step, avg_return))
                returns.append(avg_return)

        #plot the cumulative average reward during training
        plt.figure(figsize=(12,8))
        iterations = range(0, num_iterations + 1, 1000)
        plt.plot(iterations, returns)
        plt.ylabel('Average Return')
        plt.xlabel('Iterations')
        plt.show()