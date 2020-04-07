---
layout:     post
title:      tensorflow ConfigProto&GPU
subtitle:   
date:       2020-04-07
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## tensorflow ConfigProto

* log_device_placement=True : log computation device distribution
* allow_soft_placement: allow tf to use other device if the assigned device doesnot exist

        config = tf.ConfigProto(log_device_placement=True,allow_soft_placement=True)

## usage of GPU 
        #increase gpu volume with time
        config = tf.ConfigProto()
        config.gpu_options.allow_growth = True
        session = tf.Session(config=config, ...)

        #per_process_gpu_memory_fraction
        gpu_options=tf.GPUOptions(per_process_gpu_memory_fraction=0.7)  
        config=tf.ConfigProto(gpu_options=gpu_options)
        session = tf.Session(config=config, ...)

# selection of GPU

        # use GPU0
        ~/ CUDA_VISIBLE_DEVICES=0  python your.py
        # use GPU0,1
        ~/ CUDA_VISIBLE_DEVICES=0,1 python your.py

        # or in the python script
        os.environ['CUDA_VISIBLE_DEVICES'] = '0' 
        os.environ['CUDA_VISIBLE_DEVICES'] = '0,1'