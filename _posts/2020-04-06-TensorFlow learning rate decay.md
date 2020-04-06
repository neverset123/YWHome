---
layout:     post
title:      tensorflow learning rate decay
subtitle:   
date:       2020-04-06
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

to use large learning rate at the beginning, and decays step by step, function tf.train.exponential_decay() can be used

## tf.train.exponential_decay(learning rate, global_step, decay_steps, decay_rate)

* learing rate: initial learning rate
* global_step: iteration step
* decay_steps: can be set to number of batches
* decay_rate: rate of decay
* decayed_learning_rate=learining_rate*decay_rate^(global_step/decay_steps)


## Implementation

    global_step = tf.Variable(0)
    
    learning_rate = tf.train.exponential_decay(0.1, global_step, 100, 0.96, staircase=True)# create learing rate instance
    
    learning_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(....., global_step=global_step)  # use changing learning rate
