---
layout:     post
title:      tensorflow moving average
subtitle:   
date:       2020-04-06
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

google says that use averaged parameters sometimes produce significantly better results than the final trained values.

## tf.train.ExponentialMovingAverage（decay, num_updates=None, name='ExponentialMovingAverage')

* decay: decay rate, usually very close to 1 (0.99)
* num_updates: if num_updates is not set, decay will be fixed; if num_updates=global_step, then decay=min(decay, (1 + num_updates) / (10 + num_updates))

* new_value=(1−decay)×value+decay×old_value


## Implementation

        global_step=tf.Variable(0, trainable=False) #define global step
        variable_average=tf.train.ExponentialMovingAverage(decay=0.9999, num_updates=global_step) #create decay instance
        variable_averages_op=variable_averages.apply(tf.trainable_variables()) # apply decay on all trainable parameters
        train_step=tf.train.GradientDescentOptimizer(learning_rate).minize(loss, global_step=global_step)# this will automatically update global_step by adding one in each optimatization step
         with tf.control_dependencies([train_step]):
                train_op=tf.group(variable_averages_op) # put parameter updating operation in training operation

## restore from saved modell

        variables_to_restore = variable_average.variables_to_restore()
        saver = tf.train.Saver(variables_to_restore)
        saver.restore(sess, save_path)
