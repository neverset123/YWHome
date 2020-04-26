---
layout:     post
title:      tensorflow NIN
subtitle:   
date:       2020-04-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---
Network in Network is a micro network to replace the pure conv laver to extract more complex and non-linear features

## structure
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200418222226.png)
the difference between traditionale conv layer and mlpconv layer is shown above. The feature map can be obtained in similar way as CNN by sliding the micro network over the input
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200418222259.png)
deep NIN can be implemented by stacking multi-mlpconv together. since local modeling ability is increased, we can use global average pooling for classification instead of fc layer, which is more straightforwards and less over-fitting
* NIN conssits of mlpconv + GAP
* mlpconv consists of conv+mlp
* number of mlp in mlpconv can be adjusted according to need

## advantage

* mlpconv can extract more abstract feature by using mlp non-linearity, at the same time max-pooling can more meaningful but less total amount features
* the feature in different channels can learn from each other and pooling is done over channels
* directly projecting feature to classes and reducing trainable parameter by using GAP