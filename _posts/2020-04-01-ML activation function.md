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

## type of activation functions
### sigmoid

usually used for classification, output is squeezed into (0, 1)zone
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402014622.png)

### tanh
it is similar to sigmoid, but output is in (-1, 1) zone. 
Its max. gradient is larger than sigmoid, and it decrease faster than sigmoid (possibly gradient vanishing problem)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402014840.png)

### ReLU
relu works like a gate-keeper (keep negative value out with dead neutron)
It does not have the gradient vanishing problem (gradient either be 1 or 0)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200402015435.png)
it is less susceptible to vanishing gradients that prevent deep models from being trained, although it can suffer from other problems like saturated or “dead” units.
relu has sparse activation ability.
#### sparsity
sparsity means more zeros in the parameter matrix

##### Feature selection
non-important parameters will be automatically neglected, only a few important paramters will be kept for next layer, this increase modell stability during prediction

##### Interpretability
problem can be explained with key factors

## selection of activation function
1. for Hidden Layer:
Multilayer Perceptron (MLP): ReLU activation function.
Convolutional Neural Network (CNN): ReLU activation function.
Recurrent Neural Network: Tanh and/or Sigmoid activation function.
2. for output layer:
Regression: One node, linear activation.
Binary Classification: One node, sigmoid activation.
Multiclass Classification: One node per class, softmax activation.
Multilabel Classification: One node per class, sigmoid activation.

