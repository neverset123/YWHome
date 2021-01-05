---
layout:     post
title:      tensorflow Nearest Neighbors
subtitle:   
date:       2020-04-26
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

## nearest neighbor
by comparing the similarity between train and test data to take the most similar data's label as test data predicted label
* similarity comparasion
    * L1 distance  
    * L2 distance

### implementation

    class NearestNeighbor(object):
        def __init__(self):
            pass
    
        def train(self, X, Y):
            self.Xtr = X
            self.Ytr = Y
    
        def predict_L1(self, X):
            num_test = X.shape[0]
            Ypred = np.zeros(num_test)
    
            for i in range(num_test):
                #print("i:  " ,i)
                distances = np.sum(np.abs(self.Xtr - X[i, :]), axis=1)
                min_index = np.argmin(distances)
                Ypred[i] = self.Ytr[min_index]
            return Ypred
    
        def predict_L2(self, X):
            num_test = X.shape[0]
            Ypred = np.zeros(num_test)
    
            for i in range(num_test):
                #print("i:  " ,i)
                distances = np.sqrt(np.sum(np.square(self.Xtr - X[i,:]), axis = 1))
                min_index = np.argmin(distances)
                Ypred[i] = self.Ytr[min_index]
            return Ypred

        nn = NearestNeighbor()
        nn.train(Xtr, Ytr)
        Yte_predict = nn.predict_L2(Xte)

## K nearest neighbors
instead of only 1 most similar data K most similar datas are selected by comparasion and using the most appeared label as predicted label. It is one of most famous machine learning model for classification problem.

    
    #Common imports
    import numpy as np
    import pandas as pd
    import matplotlib.pyplot as plt
    import seaborn as sns
    %matplotlib inline
    #Import the data set
    raw_data = pd.read_csv('classified_data.csv', index_col = 0)
    #Import standardization functions from scikit-learn
    from sklearn.preprocessing import StandardScaler
    #Standardize the data set
    scaler = StandardScaler()
    scaler.fit(raw_data.drop('TARGET CLASS', axis=1))
    scaled_features = scaler.transform(raw_data.drop('TARGET CLASS', axis=1))
    scaled_data = pd.DataFrame(scaled_features, columns = raw_data.drop('TARGET CLASS', axis=1).columns)
    #Split the data set into training data and test data
    from sklearn.model_selection import train_test_split
    x = scaled_data
    y = raw_data['TARGET CLASS']
    x_training_data, x_test_data, y_training_data, y_test_data = train_test_split(x, y, test_size = 0.3)
    #Train the model and make predictions
    from sklearn.neighbors import KNeighborsClassifier
    model = KNeighborsClassifier(n_neighbors = 1)
    model.fit(x_training_data, y_training_data)
    predictions = model.predict(x_test_data)
    #Performance measurement
    from sklearn.metrics import classification_report
    from sklearn.metrics import confusion_matrix
    print(classification_report(y_test_data, predictions))
    print(confusion_matrix(y_test_data, predictions))
    #Selecting an optimal K value Using the Elbow Method
    error_rates = []
    for i in np.arange(1, 101):
        new_model = KNeighborsClassifier(n_neighbors = i)
        new_model.fit(x_training_data, y_training_data)
        new_predictions = new_model.predict(x_test_data)
        error_rates.append(np.mean(new_predictions != y_test_data))

    plt.figure(figsize=(16,12))
    plt.plot(error_rates)

