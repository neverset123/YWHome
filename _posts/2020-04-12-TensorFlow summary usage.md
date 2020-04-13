---
layout:     post
title:      tensorflow summary usage
subtitle:   
date:       2020-04-12
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

summary method can save the training process and relevant parameters, which can be later visualized in tensorboard

## tf.summary.scalar(tags, values, collections=None, name=None)
used to save loss and accuracy datas

    tf.summary.scalar('accuracy',acc)

## tf.summary.histogram(tags, values, collections=None, name=None) 

    # saved the variables distribution during training
    tf.summary.histogram('histogram', var)

## tf.summary.distribution
save weights distribution

## tf.summary.image
save buffer with images

## tf.summary.audio
save audio data in training

## tf.summary.FileWritter(path,sess.graph)
define target file for FileWritter to write in, later this file can be loaded into tensorboard  
if multi-plots are needed, then multi FileWritter need to be defined

    train_writer = tf.summary.FileWriter(dir,sess.graph)

## tf.summary.merge_all
save all datas during training

    merge_summary = tf.summary.merge_all()
    train_writer = tf.summary.FileWriter(dir,sess.graph)
    for step in xrange(training_step):
        train_summary = sess.run(merge_summary,feed_dict =  {...})
        train_writer.add_summary(train_summary,step)

## tf.summary.merge(inputs, collections=None, name=None)
selectively get summary information 
use tf.get_collection to get the data in collection

    tf.summary.merge([tf.get_collection(tf.GraphKeys.SUMMARIES,'accuracy'),...])  