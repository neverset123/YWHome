---
layout:     post
title:      tensorflow fully connected layer
subtitle:   
date:       2020-04-07
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

fully connected layer is the layer after cnn, its purpose to convert the feature map to the predefined categories

## tf.nn.xw_plus_b((x, weights) + biases)

it is equal to the formulation:     
    matmul(x, weights) + biases

## tf.add(tf.matmul(x, weights), biases)

## difference betwwen tf.nn.bias_add and tf.add

tf.add support all the operations provided by tf.nn.bias_add. For tf.nn.bias_add the last dimension of both oprators have to be the same, but tf.add additionally support the addtion even if the second operator has only one dimension (no dimension extension needed)

