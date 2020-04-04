---
layout:     post
title:      python random seed
subtitle:   
date:       2020-03-31
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    -tensorflow
---

the random functioin exist not only in numpy but also tensorflow    
# numpy

## np.random.seed() & np.random.RandomState()

* np.random.seed()  
this is to set a global seed for np.random;     
it can be used for mist dataset iterator, mist.train.nextbatch(), since this nextbatch API is based on numpy 

    np.random.uniform(min, max, size_of_array) #random float point number in range [min, max]
    np.random.rand(row, coloumn) # random float point number in range [0.0, 1,0)  

  

* np.random.RanddomState()
this is only a locally declared instance of randomstate, the global numpy state and other randomstates will not change

    instance=np.random.RandomState(1)
    instance.uniform(min, max, size_of_array)
    instance.rand(row, coloumn)

# tensorflow

## tf.set_random_seed()

this will create a random seed on graph level, that means that all operations (tf.random_uniform() or tf.random_normal()) in different sessions are reproducive

## tf.random_uniform() or tf.random_normal()

random seed can also applied in this generator function

    a=tf.random_uniform([1], seed=1)

