---
layout:     post
title:      concept drift in machine learning
subtitle:   
date:       2021-03-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

The performance of a model may change over time and decays as assumption and data changes, so a continuous update of ML model is needed

## Retraining Update Strategies
### Update Model on New Data Only
using a much smaller learning rate on new data so that the weights learned on the old data are not washed away.

    # update neural network with new data only
    from sklearn.datasets import make_classification
    from sklearn.model_selection import train_test_split
    from tensorflow.keras.models import Sequential
    from tensorflow.keras.layers import Dense
    from tensorflow.keras.optimizers import SGD
    # define dataset
    X, y = make_classification(n_samples=1000, n_features=20, n_informative=15, n_redundant=5, random_state=1)
    # record the number of input features in the data
    n_features = X.shape[1]
    # split into old and new data
    X_old, X_new, y_old, y_new = train_test_split(X, y, test_size=0.50, random_state=1)
    # define the model
    model = Sequential()
    model.add(Dense(20, kernel_initializer='he_normal', activation='relu', input_dim=n_features))
    model.add(Dense(10, kernel_initializer='he_normal', activation='relu'))
    model.add(Dense(1, activation='sigmoid'))
    # define the optimization algorithm
    opt = SGD(learning_rate=0.01, momentum=0.9)
    # compile the model
    model.compile(optimizer=opt, loss='binary_crossentropy')
    # fit the model on old data
    model.fit(X_old, y_old, epochs=150, batch_size=32, verbose=0)
    # save model...
    # load model...
    # update model on new data only with a smaller learning rate
    opt = SGD(learning_rate=0.001, momentum=0.9)
    # compile the model
    model.compile(optimizer=opt, loss='binary_crossentropy')
    # fit the model on new data
    model.fit(X_new, y_new, epochs=100, batch_size=32, verbose=0)

### Update Model on Old and New Data
use a much smaller learning rate and use the current weights as a starting point.

    # update model with a smaller learning rate
    opt = SGD(learning_rate=0.001, momentum=0.9)
    # compile the model
    model.compile(optimizer=opt, loss='binary_crossentropy')
    # create a composite dataset of old and new data
    X_both, y_both = vstack((X_old, X_new)), hstack((y_old, y_new))
    # fit the model on new data
    model.fit(X_both, y_both, epochs=100, batch_size=32, verbose=0)

## Ensemble Update Strategies
### Ensemble Model With Model on New Data Only
ensemble prediction of old and new model by average

    # ensemble old neural network with new model fit on new data only
    from numpy import hstack
    from numpy import mean
    from sklearn.datasets import make_classification
    from sklearn.model_selection import train_test_split
    from tensorflow.keras.models import Sequential
    from tensorflow.keras.layers import Dense
    from tensorflow.keras.optimizers import SGD
    # define dataset
    X, y = make_classification(n_samples=1000, n_features=20, n_informative=15, n_redundant=5, random_state=1)
    # record the number of input features in the data
    n_features = X.shape[1]
    # split into old and new data
    X_old, X_new, y_old, y_new = train_test_split(X, y, test_size=0.50, random_state=1)
    # define the old model
    old_model = Sequential()
    old_model.add(Dense(20, kernel_initializer='he_normal', activation='relu', input_dim=n_features))
    old_model.add(Dense(10, kernel_initializer='he_normal', activation='relu'))
    old_model.add(Dense(1, activation='sigmoid'))
    # define the optimization algorithm
    opt = SGD(learning_rate=0.01, momentum=0.9)
    # compile the model
    old_model.compile(optimizer=opt, loss='binary_crossentropy')
    # fit the model on old data
    old_model.fit(X_old, y_old, epochs=150, batch_size=32, verbose=0)
    # save model...
    # load model...
    # define the new model
    new_model = Sequential()
    new_model.add(Dense(20, kernel_initializer='he_normal', activation='relu', input_dim=n_features))
    new_model.add(Dense(10, kernel_initializer='he_normal', activation='relu'))
    new_model.add(Dense(1, activation='sigmoid'))
    # define the optimization algorithm
    opt = SGD(learning_rate=0.01, momentum=0.9)
    # compile the model
    new_model.compile(optimizer=opt, loss='binary_crossentropy')
    # fit the model on old data
    new_model.fit(X_new, y_new, epochs=150, batch_size=32, verbose=0)

    # make predictions with both models
    yhat1 = old_model.predict(X_new)
    yhat2 = new_model.predict(X_new)
    # combine predictions into single array
    combined = hstack((yhat1, yhat2))
    # calculate outcome as mean of predictions
    yhat = mean(combined, axis=-1)

### Ensemble Model With Model on Old and New Data
ensemble prediction of old and new model by average

    # define the new model
    new_model = Sequential()
    new_model.add(Dense(20, kernel_initializer='he_normal', activation='relu', input_dim=n_features))
    new_model.add(Dense(10, kernel_initializer='he_normal', activation='relu'))
    new_model.add(Dense(1, activation='sigmoid'))
    # define the optimization algorithm
    opt = SGD(learning_rate=0.01, momentum=0.9)
    # compile the model
    new_model.compile(optimizer=opt, loss='binary_crossentropy')
    # create a composite dataset of old and new data
    X_both, y_both = vstack((X_old, X_new)), hstack((y_old, y_new))
    # fit the model on old data
    new_model.fit(X_both, y_both, epochs=150, batch_size=32, verbose=0)
    
    # make predictions with both models
    yhat1 = old_model.predict(X_new)
    yhat2 = new_model.predict(X_new)
    # combine predictions into single array
    combined = hstack((yhat1, yhat2))
    # calculate outcome as mean of predictions
    yhat = mean(combined, axis=-1)
