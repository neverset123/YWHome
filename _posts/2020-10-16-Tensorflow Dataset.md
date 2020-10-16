---
layout:     post
title:      tensorflow dataset
subtitle:   
date:       2020-10-16
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

TensorFlow Datasets provides many public datasets as tf.data.Datasets

## load dataset 

    #pip install tensorflow-datasets
    import tensorflow_datasets as tfds
    mnist_data = tfds.load("mnist")
    mnist_train, mnist_test = mnist_data["train"], mnist_data["test"]
    assert isinstance(mnist_train, tf.data.Dataset)

1. Lsun
labeled images for each of 10 scene categories and 20 object categories

    tfds.image.Lsun

2. Bigearthnet
consists of 590,326 Sentinel-2 image patches

    tfds.image_classification.Bigearthnet

3. vgg_face2
face recognition dataset with large variations in pose, age, illumination, ethnicity and profession

    tfds.image_classification.VggFace2

4. aflw2k3d
used for the evaluation of 3D facial landmark detection models

    tfds.image.Aflw2k3d

5. Bair_robot_pushing_small
44,000 examples of robot pushing motions

    tfds.video.BairRobotPushingSmall

6. Voxceleb
used for speaker identification tasks

    tfds.audio.Voxceleb

7. Librispeech
1000 hours of reading English speech with a sampling rate of 16 kHz

    tfds.audio.Librispeech

8. Crema_d
used for emotion recognition

    tfds.audio.CremaD

9. C4
used to train mega models like GPT-3

    tfds.text.C4

10. civil_comments
used for sentiment analysis

    tfds.text.CivilComments