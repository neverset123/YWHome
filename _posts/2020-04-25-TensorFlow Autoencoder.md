---
layout:     post
title:      tensorflow Autoencoder
subtitle:   
date:       2020-04-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

Autoencoder(AE) is an unsupervised learning method. it can be used to compress the original input information, so that learning is eased with reduced data size. At the same time the new encoded input can have some unique features that the original input doesnot have
Autoencoder was invented before BN to train deeper neurale networks, but after BN and ResNet were implemented, this is not necessary any more. Main usage right now are Data denoising, visual dimensionality reduction and data augmentation

## process
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200425173235.png)

the original input will be encoded into a new vector，this vector will be decoded back to output vector. if the output and input are kept the same, then the encoded vector is the compressed representation of original input

## problem

* small MSE loss does not really mean good representation, beause MSE considers every pixel equally but human emphasis boundary and foreground features
* MSE loss is very sensitive to noise points, expecially with more complex data than MNIST
* training cost is high

## Variational Autoencoder
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200425184415.png)
in variational autoencoder the original input is not encoded to one vector rather two vectors-mean and standard variation, so that with these two parameter new hidden vector can be created to be decoded into augmented data

### evaluation of compression quality
the quality can be evaluated with random forest algorithm by comparing the prediction accuracy between original data and compressed data