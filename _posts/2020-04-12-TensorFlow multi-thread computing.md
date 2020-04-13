---
layout:     post
title:      tensorflow multi thread computing
subtitle:   
date:       2020-04-12
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

tensorflow offers two classes for multi threads computing:
* tf.Coordinator
it can stop all subthreads in the queue and report exceptions to the main thread
* tf.QueueRunner
it starts multi threads and pushes the tensors (train datas) into the filename queue. after calling tf.train.start_queue_runners, the tensor is ready for computing

## process
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20180401184032574.gif)

* tf.train.slice_input_producer 
operation define: extract tensors from local file system and put them in filename queue 
num_epochs needs to be defined so that OutofRangeError indicate subthreads can be closed
* tf.train.batch
operation define: extracting the tensors in filename queue and put them into file queue
* tf.train.Coordinator()
create thread coordinator
* tf.train.start_queue_runners
start the filename queue enqueue operation  
dequeue and enqueue to file queue is automatically done in tf
* sess.run
start graph computing
* coord.should_stop()
query whether subthreads should be stopped 
* coord.request_stop() & coord.join(threads)
stop all subthreads, and put the control back to main thread

## Queue
### Type
* queue1 = tf.RandomShuffleQueue()
* queue2 = tf.FIFOQueue()
### enqueue and dequeue
* enqueue_op = queue.enqueue(example)
* inputs = queue.dequeue_many(batch_size)

## QueueRunner 
the QueueRunner will create one thread for each op in enqueue_ops.Each thread will run its enqueue op in parallel with the other threads.

    qr1 = tf.train.QueueRunner(queue, [enqueue_op] * 4)
    qr2 = tf.train.QueueRunner(queue, [enqueue_op] * 4)
    tf.train.add_queue_runner(qr1) 
    tf.train.add_queue_runner(qr2) 
    threads = tf.train.start_queue_runners(sess, coord=coord)
    coord.request_stop()
    coord.join(threads)

## example

    with tf.variable_scope("queue"):
        q = tf.FIFOQueue(capacity=5, dtypes=tf.float32) # enqueue 5 batches
        # We use the "enqueue" operation so 1 element of the queue is the full batch
        enqueue_op = q.enqueue(x_input_data)
        numberOfThreads = 1
        qr = tf.train.QueueRunner(q, [enqueue_op] * numberOfThreads)
        tf.train.add_queue_runner(qr)
        input = q.dequeue() # It replaces our input placeholder
    #..........
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        coord = tf.train.Coordinator()
        threads = tf.train.start_queue_runners(coord=coord)
        #...
        try:
        # do something
        except tf.errors.OutOfRangeError:
            print 'Done training -- epoch limit reached'
        finally:
            # When done, ask the threads to stop.
            coord.request_stop()
    
        coord.join(threads)