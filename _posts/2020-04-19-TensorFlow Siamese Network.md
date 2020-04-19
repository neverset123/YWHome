---
layout:     post
title:      tensorflow Siamese Network
subtitle:   
date:       2020-04-18

author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

siamese network is a network that weights can be shared between layers    
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200419163945.png)

## usage
this network can be used to decide the similarities between two inputs
depending on the input the network structure has two variants:
* siamese network
* pseudo-siamese network

## loss function

* contrastive_loss

        def contrastive_loss(x_1, x_2, margin=1.0):
            return (x_1 * tf.square(x_2) +
                    (1.0 - x_1) * tf.square(tf.maximum(margin - x_2, 0.)))

* exp loss
L(x_1|x_2)=exp(-x_1*x_2)

* cosine loss
L(x_1|x_2)=cos(x_1*x_2)