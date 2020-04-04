---
layout:     post
title:      tensorflow backward propagation
subtitle:   
date:       2020-04-03
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## high level

    optimizer=tf.train.GradientDescentOptimizer(learning_rate=learning_rate)
    train=optimizer.minimize(cost, name='train')

## low level

for one hide layer model

    dc_dw_out, dc_db_out=tf.gradients(cost, [weights['out'], biases['out']])
    dc_dw_1, dc_db_1=tf.gradients(cost, [weights['h1'], biases['b1']])

    #update
    upd_w_1=tf.assign(weights['h1'], weights['h1']-learning_rate*dc_dw_1)
    upd_b_1=tf.assign(biases['b1'], biases['b1']-learning_rate*dc_db_1)
    upd_w_out=tf.assign(weights['out'], weights['out']-learning_rate*dc_dw_out)
    upd_b_out=tf.assign(biases['out'], biases['out']-learning_rate*dc_db_out)

    train=tf.group(upd_w_1, upd_b_1, upd_w_out, upd_b_out, name='train')