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

the usage of gpu can be checked with command
* watch -n 1 nvidia-smi # check dynamic usage
* nvidia-smi #check static usage

## tensorflow ConfigProto

* log_device_placement=True : log computation device distribution
* allow_soft_placement: allow tf to use other device if the assigned device doesnot exist

        config = tf.ConfigProto(log_device_placement=True,allow_soft_placement=True)

## usage of GPU 
select one from the two
        #increase gpu volume with time
        config = tf.ConfigProto()
        config.gpu_options.allow_growth = True
        session = tf.Session(config=config, ...)
        #or 
        #per_process_gpu_memory_fraction
        gpu_options=tf.GPUOptions(per_process_gpu_memory_fraction=0.7)  
        config=tf.ConfigProto(gpu_options=gpu_options)
        session = tf.Session(config=config, ...)

## selection of GPU

        # use GPU0
        ~/ CUDA_VISIBLE_DEVICES=0  python your.py
        # use GPU0,1
        ~/ CUDA_VISIBLE_DEVICES=0,1 python your.py

        # or in the python script
        os.environ['CUDA_VISIBLE_DEVICES'] = '0' 
        os.environ['CUDA_VISIBLE_DEVICES'] = '0,1'

        # or in ConfigProto()
        config = tf.ConfigProto()
        config.gpu_options.visible_device_list = '0'

# using seperate config file 

        def set_gpu(ratio=0, target='memory'):
        """
        config gpu，(0, 1] ratio of gpu usage, 0 represents adaptive
        :param ratio:
        :param target:
        :return:
        """
        command1 = "nvidia-smi -q -d Memory | grep -A4 GPU | grep Free | awk '{print $3}'"
        command2 = "nvidia-smi -q | grep Gpu | awk '{print $3}'"
        memory = list(map(int, os.popen(command1).readlines()))
        gpu = list(map(int, os.popen(command2).readlines()))
        if memory and gpu:
                if target == 'memory':
                num = (1, 0)[memory[0] > memory[1]]
                else:
                num = (0, 1)[gpu[0] > gpu[1]]
                print('>>> Free Memory       : GPU0 %6d MiB | GPU1 %6d MiB' % (memory[0], memory[1]))
                print('>>> Volatile GPU-Util : GPU0 %6d %%   | GPU1 %6d %% ' % (gpu[0], gpu[1]))
                print('>>> Using GPU%d' % num)
                import tensorflow as tf
                config = tf.ConfigProto()
                config.gpu_options.visible_device_list = str(num)  # 选择GPU
                if ratio == 0:
                config.gpu_options.allow_growth = True
                else:
                config.gpu_options.per_process_gpu_memory_fraction = ratio
                sess = tf.Session(config=config)
                from keras import backend as K
                K.set_session(sess)
        else:
                print('>>> Could not find the GPU')
