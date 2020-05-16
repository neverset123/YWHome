---
layout:     post
title:      tensorflow functions
subtitle:   
date:       2020-04-26
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

tf.cast
tf.argmax
tf.argmin
tf.equal

## tf.cast()
Casts a tensor to a new type 

        tf.cast(
            x,
            dtype,
            name=None
        )

## tf.argmax()
Returns the index with the largest value across axes of a tensor

    tf.argmax(
        input,
        axis=None,
        name=None,
        dimension=None,
        output_type=tf.int64
    )

## tf.argmin()
Returns the index with the smallest value across axes of a tensor

        tf.argmin(
        input,
        axis=None,
        name=None,
        dimension=None,
        output_type=tf.int64
    )

## tf.equal()
compare each element in the tensor, and return bool value tensor in same size

    tf.equal(
        x,
        y,
        name=None
    )