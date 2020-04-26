---
layout:     post
title:      tensorflow Filter Response Normalization
subtitle:   
date:       2020-04-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---
To avoid that normalization dependes on batch size will lead to bad results when batch size on test and training is different, filter Response Normalization is introduced

## structure
Filter Response Normalization layer consists of FRN(filter response normalization) and TLU(Threadhold linear Unit)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200419151651.png)
the shape of input x is [B, W, H, C], N=BxW (pixel number)
the normalization is done on axis=[1,2] (HxW), so every channel is normalized seperately.
no variance on batch dimension is included in calculation, which means that normalization is done on batch size=1, so the normalization is not dependent on batch size

## difference to other normalization
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200419154754.png)
the differnce between FRN and other normalization is shown above:
* FRN is done on the red marked cubics
* batch norm is done on all cubics in all batches
* layer norm is done on  all cubics in the all channel