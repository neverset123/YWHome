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

tf.get_variable can define variable during training and load variable from saved model during testing
    #initializer=tf.random_normal(), or tf.constant(), tf.ones()
    tf.Variable(initializer, name='v')
    sess.run(v.initializer)
    # or
    ini=tf.constant_initializer([5])
    x=tf.get_variable('x',shape=[1], initializer=init)
    sess.run(x.initializer)

## namespace

* variable_scope
* name_scope

tf.Variable can generate different name_scope automatically if with same name but tf.get_variable not   
using tf.Variable: tf.name_scope() and tf.variable_scope() add prefix to name attributes of Variable and  op
using tf.get_variable(): tf.name_scope doesnot add prefix to name attributes of variable, tf.variable_scope does


format: 
    Variable_scope/name_scope/var:0

using  

    with tf.variable_scope('layer1_conv1'):
    or
    with tf.name_scope('layer2_pool1'):

can define different name or variable scope for different layers
