---
layout:     post
title:      tensorflow Initialization
subtitle:   
date:       2020-04-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---


the initialization of weight(or kernel) can have signifikant effect on the speed and accuracy of the model. there are several way to initialize the weight

* random
* xavier
* He

the biase is usually initialized to 0

## Initialization with truncated_normal

the drawback of this initialization is that if nn is deep, the optimation will be difficult, but this problem will be conpensated by BN

    weights=tf.Variable(tf.truncated_normal(shapre=weights_shape, mean=0.0, stddev=0.01, dtype=tf.float32, seed=seed))

## Initialization with Xavier Initializer

xavier initialization can keep data in good distribution even in deeper layer, especially when activation function is sigmoid or tanh

    initializer=tf.contrib.layers.xavier_initializer()
    weights=tf.Variable(initializer(weights_shape))

## Initialization with He Inizializer

if activation function is relu it is better to use He initialization

    initializer=tf.contrib.layers.variance_scaling_initializer()
    weights=tf.Variable(initializer(weights_shape))