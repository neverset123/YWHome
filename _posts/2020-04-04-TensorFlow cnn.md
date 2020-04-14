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

## tf.layers.conv2d()
more advanced api of tensorflow

conv2d(inputs, filters, kernel_size, 
    strides=(1, 1), 
    padding='valid', 
    data_format='channels_last', 
    dilation_rate=(1, 1),
    activation=None, 
    use_bias=True, 
    kernel_initializer=None,
    bias_initializer=<tensorflow.python.ops.init_ops.Zeros object at 0x000002596A1FD898>, 
    kernel_regularizer=None,
    bias_regularizer=None, 
    activity_regularizer=None, 
    kernel_constraint=None, 
    bias_constraint=None, 
    trainable=True, 
    name=None,
    reuse=None)
* imputs: [batch, in_height, in_width, in_channels]
* filters: out_channel
* kernel_size: (filter_height, filter_width) or one integer(height equal width)

## pooling

### tf.nn.max_pool(value, ksize, strides, padding, name=None)

* valuevalue: feature map tensor with shape [batch, height, width, cnannels]
* ksize: pooling tensor with shape [1, height, width, 1]
* strides: step size tensor with shape [1, stride, stride, 1]
* padding: "VALID" or "SAME"
* return: feature map [batch, height, width, channels]
