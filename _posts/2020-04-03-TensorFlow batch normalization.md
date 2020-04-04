---
layout:     post
title:      tensorflow batch normalization
subtitle:   
date:       2020-04-03
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

batch normalization is introduced to solve Internal Covariate Shift problem
Internal Covariate Shift means that parameter changes in one layer can lead to input data distribution changes for next layer
batch normalization can in some sense reduce gradient vanishing problem and increase the network capacity so that learning is accelerated

## batch normalization

batch normalization is done on mini-batch level

* normatlization is done on each feature on the same layer, to make the input for next layer keep mean on 0, variance on 1
* afterwards two learnable parameters are introduced to recover the expressability of the datas

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20200403133804.png)

### drawback

BN is not feasable for following cases

* batch size very small
* dynamic network structure (rnn)


## implementation

during training the mean and variance will be noted to update moving_mean and moving_variance, they will be used for test data batch normalization
batch normalization is usually put before activation if activation is sigmoid or tanh; if activation is ReLU before or after  could make little difference
Even if you implement the ConvWithBias+BatchNorm, it will behave like ConvWithoutBias+BatchNorm.

### tf.layers.batch_normalization()

the update of moving_mean and moving_variance are by default placed in tf.GraphKeys.UPDATE_OPS, they need to be updated before training starts
    x_norm=tf.layers.batch_normalization(x, training=is_training)
    #...
    update_ops=tf.get_collection(tf.Graphkeys.UPDATE_OPS)
    with tf.control_dependencies(update_ops):
        train_op=optimizer.minimizer(loss)

        

### tf.control_dependencies()
it guarantees that the operations in the function parameter are done first before the following operations 

### tf.GraphKeys.UPDATE_OPS

tf.GraphKeys contains all standard graph collection (tf.Variable...). During batch normalization it will update mean and variance