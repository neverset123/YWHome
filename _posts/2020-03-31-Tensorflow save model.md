---
layout:     post
title:      tensorflow save model
subtitle:   
date:       2020-03-31
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## content of tensorflow model

- meta graph    
    it contains tensorflow graph (variables, operations and groups...)
- checkpoint file   
    it contains weights, bias, gradients and other variables.
    this file is splitted into two file since tensorflow 0.11   
    * mymodel.data-00000-of-00001
    * mymodel.index

    tensorflow will additionally save a checkpoint file, which contain the latest checkpoint file information

## save model

    import tensorflow as tf
    w1=tf.Variable(tf.random_normal(shape=[2]), name='w1')
    w2=tf.Variable(tf.random_normal(shape=[5]), name='w2')
    saver=tf.train.Saver([w1,w2]) # tf.train.Saver()->save all parameters if no parameter list is given
    sess=tf.Session()
    sess.run(tf.global-variables_initializer())
    saver.save(sess, 'my_model', global_step=1000) # save modell every 1000 steps

## import trained model

    with tf.Session() as sess:
        saver=tf.train.import_meta_graph('my-model.meta')
        saver.restore(sess, tf.train.latest_checkpoint('./'))
        print(sess.run('w1:0')) 

    # from multi modells automatically load latest model
    model_path="checkpoint"
    if not model_path.endswith('/'):
        model_path+='/'
    chkpt_fname=tf.train.latest-checkpoint(model_path)


## usage of imported model

### running same model with different data

    graph=tf.get_default_graph()
    w1=graph.get_tensor_by_name("w1:0")
    w2=graph.get_tensor_by_name("w2:0")
    feed_dict={w1:13.0, w2:17.0} # create feed-dict to feed new data

    op_to_restore=graph.get_tensor_by_name("op_to_restore:0") # access the operation 
    print sess.run(op_to_restore, feed_dict)

### adding more layers to old model

    add_on_op=tf.multiply(op_to_restore, 2) # add new lay to the existing model

### create new model from old model

    fc7=graph.get_tensor_by_name('fc7:0')
    fc7=graph.stop_gradient(fc7) # change the 7th layer gradient
    fc7_shape=fc7.get_shape().as_list()

    new_outputs=2
    weights=tf.Variable(tf.truncated_normal([fc7_shape[3], new_outpus], stddev=0.05))
    biases=tf.Variable(tf.constant(0.05, shapre=[num_outputs]))
    output=tf.matmul(fc7, weights)+biases
    pred=tf.nn.softmax(output)







