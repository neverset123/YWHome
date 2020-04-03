---
layout:     post
title:      tensorflow dropout
subtitle:   
date:       2020-04-02
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

dropout can decrease the overfit probability during training and increase the accuracy during prediction

dropout should be used on in training and not in validation and testing

dropout is used after activation function

## tf.layers.dropout

rate is dropout rate    
in training mode (training=True), the part after dropout will be returned; in other modes (training=False), no dropout is applied.  
this is usually used combined with tf.layers.dense()

    tf.layers.dropout(inputs, rate=0.5, training=False, name=None)

## tf.nn.dropout

the rate is the probability of an element to be kept

    tf.nn.dropout(inputs, keep_prob=0.5)
