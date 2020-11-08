---
layout:     post
title:      machine-learning activation function
subtitle:   
date:       2020-04-01
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

the purpose of activation function is to increase the non-linearity of ML model, so that classification can be done better.
it can also be imagined as twisting the space to find linear boundary

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402014156.png)

## sigmoid

usually used for classification, output is squeezed into (0, 1)zone
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402014622.png)

## tanh

it is similar to sigmoid, but output is in (-1, 1) zone. 
Its max. gradient is larger than sigmoid, and it decrease faster than sigmoid (possibly gradient vanishing problem)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402014840.png)

## ReLU

relu works like a gate-keeper (keep negative value out with dead neutron)
It doesnot have the gradient vanishing problem (gradient either be 1 or 0)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402015435.png)

relu has sparse activation ability
### sparsity

sparsity means more zeros in the parameter matrix

#### Feature selection

non-important parameters will be automatically neglected, only a few important paramters will be kept for next layer, this increase modell stability during prediction

#### Interpretability

problem can be explained with key factors