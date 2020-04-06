---
layout:     post
title:      tensorflow cnn
subtitle:   
date:       2020-04-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---


## tf.nn.conv2d(input, filter, strides, padding, use_cudnn_on_gpu=None, name=None)

* input: input tensor for converlution with shape [batch, in_height, in_width, in_channels]
* filter: kernel tensor with shape [filter_height, filter_width, in_channels, out_channels]
* stride: step size tensor with shape [step_batch, step_height, step_width, step_channel]
* padding: option for converlution: "SAME"->with boundary, "VALID"->no boundary
* use_cudnn_on_gpu: whether to accelerate calculation with cudnn
* return: feature map

normally we need a conv2d wrapper function, so that the input and kernel matrix can be formulated correctly and adding activation function after converlutional computation

## pooling

### tf.nn.max_pool(value, ksize, strides, padding, name=None)

* valuevalue: feature map tensor with shape [batch, height, width, cnannels]
* ksize: pooling tensor with shape [1, height, width, 1]
* strides: step size tensor with shape [1, stride, stride, 1]
* padding: "VALID" or "SAME"
* return: feature map [batch, height, width, channels]
