---
layout:     post
title:      tensorflow regulazition
subtitle:   
date:       2020-04-06
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

regulazition is to add model complexity item in loss function to avoid overfitting, so the new loss function is J(\theta)+\lambda *R(w)

## Implementation
* create a regulazition method
* apply method on the weights

### regulazition method
* L1 regulazition   
regularizer=tf.contrib.layers.l1_regularizer(lambda, scope=None)

* L2 regulazition   
regularizer=tf.contrib.layers.l2_regularizer(lambda, scope=None)

* mix regulazition
regularizer=tf.contrib.layers.sum_regularizer(regularizer_list, scope=None)

### applying regulazition
* regulazition_loss=tf.contrib.layers.apply_regularization(regularizer, weights_list=None)  
weights_list=None means: GraphKeys.WEIGHTS will be automatically taken
This regulazition_loss can be added onto the loss function

        tf.add_to_collection(tf.GraphKeys.REGULARIZATION_LOSSES, regulazition_loss)
        reg_losses = tf.get_collection(tf.GraphKeys.REGULARIZATION_LOSSES) 
        loss=tf.add_n(reg_losses)   

* using with scope


        with tf.variable_scope('var', initializer=tf.random_normal_initializer(), regularizer=regularizer):       
            weight = tf.get_variable('weight', shape=[8], initializer=tf.ones_initializer())

    regularization_loss = tf.reduce_sum(tf.get_collection(tf.GraphKeys.REGULARIZATION_LOSSES)) 

* using slim

        with slim.arg_scope([slim.conv2d, slim.fully_connected],
                            activation_fn=tf.nn.relu,
                            weights_regularizer=slim.l2_regularizer(lambda)）：



