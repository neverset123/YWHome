---
layout:     post
title:      tensor debug
subtitle:   
date:       2020-10-11
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

the library to debug tensor operation dimension is called TensorSensor

* Augments the exception object's message created by the underlying tensor library.
* Gives a visual representation of the tensor sizes involved in the offending operation; only the operands and operator involved in the exception are highlighted, while the other Python elements are de-highlighted.

## example

    import tsensor
    import tensorflow as tf
    W = tf.random.uniform((d,n_neurons))
    b = tf.random.uniform((n_neurons,1))
    X = tf.random.uniform((n,d))
    with tsensor.clarify():
        Y = W @ tf.transpose(X) + b
    #show error
    ![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201011174745.png)