---
layout:     post
title:      tensorflow LeNet&AlexNet&VGG
subtitle:   
date:       2020-04-07
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## development of CNN 

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200411142855.png)

## LeNet

there are 2 conv layers, 2 pooling layers, 2 fc layers and 1 output layer,  tanh or sigmoid activation function
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200411143113.png)

* Conv1: 6 kernels with size of 5x5 , stride=1, padding=0    
purpose is to increase the feature signal and decrease noise

* Average Pool1: 2x2 filter, stride=2, padding=0    
purpose is to decrease data size and keep usefully information at the same time and avoid overfitting

* Conv2: 16 kernels with size of 5x5, stride=1, padding=0   
* Average Pool2: 2x2 filter, stride=2, padding=0    
* Fc3: output_node=120
* Fc4: output_node=84
* out5: softmax
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200411145713.png)

## AlexNet
there are 5 conv layers, 3 pooling layers, 2 fc layers, 1 output layer
implemented dropout
use ReLu activation
max. pooling

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200411150222.png)

AlexNet is to be considered as modul design. For example for converlution conv and pooling are combined together, functions(activation and pooling) are inserted inbetween to control the data
* modul1/modul2:    
structure: conv+ReLu+Pooling+Normalization
conv: 96(conv1)/256(conv2) kernels with size of 11x11(conv1)/5x5(conv2), stride=4(conv1)/1(conv2), padding=0(conv1)/2(conv2) 
max pooling: 3x3 filter, stride=2, padding=0  
norm: local_size=5
* modul3/modul4:    
structure: conv+ReLu (no pooing because of smaller feature size)
conv: 384 kernels with size of 3x3, stride=1, padding=1  
* modul5    
structure: conv+ReLu+pooling
conv: 256 kernels with size of 3x3, stride=1, padding=1 
max pooling: 3x3 filter, stride=2

* modul6/modul7/modul8  
structure: fc+ReLu+dropout
fc: output_node=4096(fc6 and fc7) /class_num(fc8)    


