---
layout:     post
title:      tensorflow LRN
subtitle:   
date:       2020-04-10
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

Local Response Normalization (LRN) is first introduced in AlexNet, is used after activation and pooling to increase normalization ablitity

## LRN maths background

physical meaning: 
the output feature of one point from previous layer is averaged with all surrounding points 
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200410164213.png)

a: output from the previous pooling layer   
N: image channels   
n/2: kernel map depth radius that to be included in the calculation
k: bias 

recommended values: k=2,n=5,aloha=1*e-4,beta=0.75

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200410171005.png)

## Imlementation

    #tf.nn.local_response_normalization(input, depth_radius=None, bias=None, alpha=None, beta=None, name=None)  
    # return is new feature map with same map size of input matrix
    y = tf.nn.lrn(input=x,depth_radius=2,bias=0,alpha=1,beta=1)

## furture

LRN is replaced by BN with better performance


