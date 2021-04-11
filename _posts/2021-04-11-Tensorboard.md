---
layout:     post
title:      tensorboard
subtitle:   
date:       2021-04-11
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---


## hyperparameter optimization
hyperparameters include:
* No. of hidden layers
* No. of units or nodes in a hidden layer
* Learning rate
* Dropout rate
* Epochs or iterations
* Optimizers like SGD, Adam, AdaGrad, Rmsprop, etc.
* Activation functions like ReLU, sigmoid, leaky ReLU etc.
* Batch size
optimization methods:
* Manual search
* Grid search: searhing all possible combinations of the specified hyperparameters resulting in a cartesian product.
* Random search: not every combination of Hyperparameter is tried, but rather random selected
* Bayesian optimization: using prior information about hyperparameters including accuracy or loss of the model help select hyperparameter.

### example optimization model
an example with grid search

    import tensorflow as tf
    from tensorboard.plugins.hparams import api as hp
    import datetime
    from tensorflow.keras.models import Sequential
    from tensorflow.keras.layers import Dense, Conv2D, Flatten, Dropout, MaxPooling2D
    from tensorflow.keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img
    import numpy as np

    # Load the TensorBoard notebook extension
    %load_ext tensorboard

    #create classification model
    BASE_PATH = 'Data\\dogs-vs-cats\\train\\'
    TRAIN_PATH='Data\\dogs-vs-cats\\train_data\\'
    VAL_PATH='Data\\dogs-vs-cats\\validation_data\\'batch_size = 32 
    epochs = 5
    IMG_HEIGHT = 150
    IMG_WIDTH = 150

    #data for training and validation
    train_image_generator = ImageDataGenerator(rescale=1./255, rotation_range=45,width_shift_range=.15,height_shift_range=.15,horizontal_flip=True,zoom_range=0.3)
    validation_image_generator = ImageDataGenerator(rescale=1./255)

    train_data_gen = train_image_generator.flow_from_directory(
    batch_size = batch_size,
    directory=TRAIN_PATH,
    shuffle=True,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    class_mode='categorical')  
    val_data_gen = validation_image_generator.flow_from_directory(batch_size = batch_size,                                                              directory=VAL_PATH,                                                              target_size=(IMG_HEIGHT, IMG_WIDTH),
    class_mode='categorical') 

    #Create hyperparameters
    HP_NUM_UNITS=hp.HParam('num_units', hp.Discrete([ 256, 512]))
    HP_DROPOUT=hp.HParam('dropout', hp.RealInterval(0.1, 0.2))
    HP_LEARNING_RATE= hp.HParam('learning_rate', hp.Discrete([0.001, 0.0005, 0.0001]))
    HP_OPTIMIZER=hp.HParam('optimizer', hp.Discrete(['adam', 'sgd', 'rmsprop']))
    METRIC_ACCURACY='accuracy'

    #log file setting
    log_dir ='\\logs\\fit\\' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    with tf.summary.create_file_writer(log_dir).as_default():
        hp.hparams_config(
        hparams=
        [HP_NUM_UNITS, HP_DROPOUT,  HP_OPTIMIZER, HP_LEARNING_RATE],
        metrics=[hp.Metric(METRIC_ACCURACY, display_name='Accuracy')],
        )

    #set optimization model
    def create_model(hparams):
        model = Sequential([
        Conv2D(64, 3, padding='same', activation='relu', 
            input_shape=(IMG_HEIGHT, IMG_WIDTH ,3)),
        MaxPooling2D(),
        #setting the Drop out value based on HParam
        Dropout(hparams[HP_DROPOUT]),
        Conv2D(128, 3, padding='same', activation='relu'),
        MaxPooling2D(),
        Dropout(hparams[HP_DROPOUT]),
        Flatten(),
        Dense(hparams[HP_NUM_UNITS], activation='relu'),
        Dense(2, activation='softmax')])
        
        #setting the optimizer and learning rate
        optimizer = hparams[HP_OPTIMIZER]
        learning_rate = hparams[HP_LEARNING_RATE]
        if optimizer == "adam":
            optimizer = tf.optimizers.Adam(learning_rate=learning_rate)
        elif optimizer == "sgd":
            optimizer = tf.optimizers.SGD(learning_rate=learning_rate)
        elif optimizer=='rmsprop':
            optimizer = tf.optimizers.RMSprop(learning_rate=learning_rate)
        else:
            raise ValueError("unexpected optimizer name: %r" % (optimizer_name,))
        
        # Comiple the mode with the optimizer and learninf rate specified in hparams
        model.compile(optimizer=optimizer,
                loss='categorical_crossentropy',
                metrics=['accuracy'])
        
        #Fit the model 
        history=model.fit_generator(
        train_data_gen,
        steps_per_epoch=1000,
        epochs=epochs,
        validation_data=val_data_gen,
        validation_steps=1000,
        callbacks=[
            tf.keras.callbacks.TensorBoard(log_dir),  # log metrics
            hp.KerasCallback(log_dir, hparams),# log hparams
            
        ])
        return history.history['val_accuracy'][-1]

    def run(run_dir, hparams):
        with tf.summary.create_file_writer(run_dir).as_default():
            hp.hparams(hparams)  # record the values used in this trial
            accuracy = create_model(hparams)
            #converting to tf scalar
            accuracy= tf.reshape(tf.convert_to_tensor(accuracy), []).numpy()
            tf.summary.scalar(METRIC_ACCURACY, accuracy, step=1)

    #run optimization
    session_num = 0
    for num_units in HP_NUM_UNITS.domain.values:
    for dropout_rate in (HP_DROPOUT.domain.min_value, HP_DROPOUT.domain.max_value):
        for optimizer in HP_OPTIMIZER.domain.values:
            for learning_rate in HP_LEARNING_RATE.domain.values:
            hparams = {
                HP_NUM_UNITS: num_units,
                HP_DROPOUT: dropout_rate,
                HP_OPTIMIZER: optimizer,
                HP_LEARNING_RATE: learning_rate,
            }
            run_name = "run-%d" % session_num
            print('--- Starting trial: %s' % run_name)
            print({h.name: hparams[h] for h in hparams})
            run('logs/hparam_tuning/' + run_name, hparams)
            session_num += 1

### visualization with tensorboard

1. cmd
python -m tensorboard.main --logdir="logs/hparam_tuning"
2. jupyter-notebook
%tensorboard --logdir='\logs\hparam_tuning'
