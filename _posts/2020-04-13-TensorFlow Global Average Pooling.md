---
layout:     post
title:      tensorflow Global Average Pooling
subtitle:   
date:       2020-04-12
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

Global Average Pooling (GAP) is an replacement of FC layer, which has two benefits
* more native to categorize feature map
* less parameter to optimize to avoid overfitting

## principle
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414191711.png)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200414191948.png)

traditional pooling is to keep significat feature, reduce feature map size and increase kernel FOV
However the fc layer takes too many parameters into computation. The GAP just replace the work of fc layers for classification
test shows that the GAP has more stable results, but slower convergence 
