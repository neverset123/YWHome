---
layout:     post
title:      tensorflow basic notes
subtitle:   
date:       2020-03-30
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## tf.Variable

### initialization
variables in tensorflow must be initialized with tf.global_variables_initializer

    sess.run(tf.global_variables_initializer())


### definition

variable definition can be done with tf.Variable or tf.get_variable

    tf.Variable(3, name='v')
    sess.run(v.initializer)
    # or
    ini=tf.constant_initializer([5])
    x=tf.get_variable('x',shape=[1], initializer=init)
    sess.run(x.initializer)

## namespace

* variable_scope
* name_scope

tf.Variable can generate different name_scope automatically if with same name but tf.get_variable not
format:
Variable_scope/name_scope/var:0
