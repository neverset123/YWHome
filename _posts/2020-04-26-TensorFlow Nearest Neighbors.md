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
instead of only 1 most similar data K most similar datas are selected by comparasion and using the most appeared label as predicted label
