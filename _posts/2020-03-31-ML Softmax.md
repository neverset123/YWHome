---
layout:     post
title:      tensorflow basic notes
subtitle:   
date:       2020-03-31
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

## softmax function

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200401191034.png)

softmax is used to to project multi-output values in (0, 1) section, so that a proper selection according to max. probability can be made

the mathmatical expression is shown:
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200401191542.png)

## loss and gradient

the loss is expressed with cross-entropy function:
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200401191805.png)

y: true value
a: predicted value with softmax

### Partial derivative
if j not equal i: aj
if j equal i: ai-1
[ i is the final selected one
  j is the item to derivate partially]
