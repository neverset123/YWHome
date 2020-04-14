---
layout:     post
title:      tensorflow DenseNet
subtitle:   
date:       2020-04-12
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

Densely Connected Convolutional Networks (DenseNets)
Each layer has direct access to the gradients from the loss function and the original input signal, leading to an implicit deep supervision
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414134603.png)
comopared with ResNet, it is less costly in computation due to less parameters while at the same time has the same accuracy; better generalization performance with small datasets (no data augmentation needed)
gradient vanishing problem is enlightened because of earlier layer connection

## structure
the input will be first be converluted with [7x7] kernel with stride of 2 and max pooled with [3x3] filter with stride of 2. Afterwards is repetation of DenseBlock and transition. at the end is global average pooling with [7x7] filter and 1000 fc and softsmax classification
the input will be first be converluted with [7x7] kernel with stride of 2 and max pooled with [3x3] filter with stride of 2. Afterwards is repetation of DenseBlock and transition. at the end is global average pooling with [7x7] filter and 1000 fc and softsmax classification

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414143106.png)

* DenseNet consists of Dense Block and transition layer
* Bottleneck layer : BN-ReLU-Conv(1x1)-BN-ReLU-Conv(3x3) in the dense block, purpose is to reduce the input channels of feature maps, DenseNet with bottleneck layer is called DenseNet-B
* transition layer: 1x1 conv between dense blocks, purpose is to compress feature map channels, output channel is theta * m (m is input channels, /theta is compression factor, 0</theta<1), DenseNet with both bottleneck and transition layers is called DenseNet-BC
* growth rate k: every HI layer will generate k new feature map channels, so the lth layer has k0+k*(l-1) input feature maps. k is relatively small in DenseNet
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414162258.png)
HI is BN-RELU-conv(3x3) operatioin, [x0,x1,...xl-1] represents concatenation of feature maps from 0 to l-1

## difference
traditional CNN is to find F(x) to fit the target;  
ResNet is instead to fit G(x) at 0 point rather than F(x), which will reduce the probility of gradient vanishing problem
DenseNet is to use the earlier extracted feature directly rather than extract them again   

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414173041.png)
