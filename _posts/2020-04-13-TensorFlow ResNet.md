---
layout:     post
title:      tensorflow ResNet
subtitle:   
date:       2020-04-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---
ResNet consists of multi shallow network blocks (residual blocks)
the purpose of ResNet is to keep model from degradation if NN depth increases
advantage:
* deeper networks
* solve model degradation problem
* converge faster

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200415173820.png)
## principle
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200415133948.png)

H(x)=F(x)+x means that adding an identity mapping item x to the previous target function F(x). when F(x)=0,identity mapping exists, so right now is to find a mapping relationship F(x) between residuals of (ouput-input) and input rather than mapping relationship H(x) between input and output
shortcut connection is done before activation.  
To keep dimension matches we use H(x)=F(x,{Wi})+Ws*x

in one building block there should be at least two weight layers, usually 2-3

## structure
input will be first processed by a [7x7] conv layer(stride=2), then max pooled with [3x3] filter (stride=2). Afterwards is stacking of Residual blocks(normal build blocks for layer < 50; bottleneck blocks for layer >50). At the end is global average pooling and softmax
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200415171432.png)

* building block vs bottleneck block
one residual block contains multi building blocks or bottleneck blocks
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200415171652.png)