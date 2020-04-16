---
layout:     post
title:      tensorflow Variables
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

## namespace & variablespace

* variable_scope(name_or_scope=None, reuse=False)
* name_scope()

default variable_scop().name is blank

tf.Variable can generate different name_scope automatically if with same name but tf.get_variable not   

using tf.Variable: tf.name_scope() and tf.variable_scope() add prefix to name attributes of Variable and operations 

using tf.get_variable(): tf.name_scope doesnot add prefix to name attributes of variable, tf.variable_scope does

format: (the order of variable_scope and name_scope depends on the definition of these scopes)
    Variable_scope/name_scope/var:0 (:0 means that this variable is the first output from its operation)

using  

    with tf.variable_scope('layer1_conv1'):
    or
    with tf.name_scope('layer2_pool1'):

can define different name or variable scope for different layers

### reuse mode of variable_scope

#### principle
* tf.get_variable_scope() can get the current variable_scope, .name and .reuse is the attribute of this object
* tf.get_variable_scope().reuse_variables() can activate the resue option   
* reuse properity can be inherited by the child-variable-scope
* the resue properity is only valid in its own with-scope, but the created variable in the scope is still valid

        with tf.variable_scope('vs'):
            v=tf.get_variable('v',shape=())

        with tf.variable_scope('vs',reuse=True):
            reused_v=tf.get_variable('v',shape=()) #this is the earlier defined variable    

* scope can be copied, all the properties will be copied

        with tf.variable_scope('vs2') as scope:
        ...
        with tf.variable_scope(scope): 
        ...

#### effect on tf.Variable()
* tf.Variable() can not reuse variable, so it is not effected by reuse mode of variable_scope
if there is already variable with the same name in the variable scope, a postfix will be added to the newly created varaible

#### effect on tf.get_variable()
* if non-reuse  
    * if variable with same name exists
        * existing variable was created with tf.Variable(), then postfix will be added on the newly created variable
        * existing variable was created with tf.get_variable(), it is not allowed to be created again.
    if not exist then create a new variable
* if resue
    * tf.get_variable can reuse the variable only if
        * earlier variable was created by tf.get_variable() not tf.Variable()
        * variable with same name in the same scope exists, if not will throw error
* if reuse=tf.AUTO_REUSE: if reuse possible then reuse, if not then create a new variable
