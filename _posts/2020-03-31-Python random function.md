---
layout:     post
title:      python random function
subtitle:   
date:       2020-03-31
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---
# np.random.seed() & np.random.RandomState()

## np.random.seed()
this is to set a global seed for np.random.

    np.random.uniform(min, max, size_of_array) #random float point number in range [min, max]
    np.random.rand(row, coloumn) # random float point number in range [0.0, 1,0)

## np.random.RanddomState()
this is only a locally declared instance of randomstate, the global numpy state and other randomstates will not change

    instance=np.random.RandomState(1)
    instance.uniform(min, max, size_of_array)
    instance.rand(row, coloumn)
    