---
layout:     post
title:      Notificaiton
subtitle:   
date:       2020-10-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---


## notification methods
there are multiple ways to get notified when a job a done
### beep

    import os 

    def make_noise():
        '''Make noise after finishing executing a code'''
        duration = 1  # seconds
        freq = 440  # Hz
        os.system('play -nq -t alsa synth {} sine {}'.format(duration, freq))

### email or message

    #pip install knockknock
    from knockknock import email_sender
    @email_sender(recipient_emails=["youremail@gmail.com"], sender_email="anotheremail@gmail.com")
    def main():
        even_arr = []
        for i in range(10000):
            if i%2==0:
                even_arr.append(i)

### Tensordash

    $pip install tensor-dash
1. tf.keras

    from tensordash.tensordash import Tensordash

    histories = Tensordash(
        ModelName = '<YOUR_MODEL_NAME>',
        email = '<YOUR_EMAIL_ID>', 
        password = '<YOUR PASSWORD>')
        
    try:
        model.fit(
        X_train, 
        y_train, 
        epochs = epochs, 
        validation_data = validation_data, 
        batch_size = batch_size, 
        callbacks = [histories])

    except:
        histories.sendCrash()

2. pytorch

    from tensordash.torchdash import Torchdash

    histories = Torchdash(
        ModelName = '<YOUR_MODEL_NAME>',
        email = '<YOUR_EMAIL_ID>', 
        password = '<YOUR PASSWORD>')

    try:
        for epoch in range(epochs):
            losses = []
            for data in trainset:
                X, y = data
                net.zero_grad()
                output = net(X.view(data_shape))
                loss = F.nll_loss(output, y)
                loss.backward()
                optimizer.step()
            losses = np.asarray(losses)
            histories.sendLoss(loss = np.mean(losses), epoch = epoch, total_epochs = epochs) // Add this line to your training loop

    except:
        histories.sendCrash()

3. tensorflow

    from tensordash.tensordash import Customdash

    histories = Customdash(
        ModelName = '<YOUR_MODEL_NAME>',
        email = '<YOUR_EMAIL_ID>', 
        password = '<YOUR PASSWORD>')

    try:

        for epoch in range(num_epochs):
            epoch_loss_avg = tf.keras.metrics.Mean()
            epoch_accuracy = tf.keras.metrics.SparseCategoricalAccuracy()

            for x, y in train_dataset:

                loss_value, grads = grad(model, x, y)
                optimizer.apply_gradients(zip(grads, model.trainable_variables))

                epoch_loss_avg(loss_value)
                epoch_accuracy(y, model(x, training=True))

            train_loss_results.append(epoch_loss_avg.result())
            train_accuracy_results.append(epoch_accuracy.result())

            histories.sendLoss(loss = epoch_loss_avg.result(), accuracy = epoch_accuracy.result(), epoch = epoch, total_epochs = epochs) // Add this line to your training loop

    except:
        histories.sendCrash()