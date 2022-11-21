---
layout:     post
title:      Machine Learning Interpretability
subtitle:   
date:       2020-10-24
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

Regarding model interpretability, in addition to linear models and decision trees, which are inherently well interpretable, many models in sklean have the importance interface, and you can view the importance of features.

## Classic global feature importance
using the plot_importance() method gives an attractively simple bar-chart representing the importance of each feature in our dataset
1. Weight. The number of times a feature is used to split the data across all trees.

    xgboot.plot_importance(model, importance_type="weight")

2. Cover. The number of times a feature is used to split the data across all trees weighted by the number of training data points that go through those splits.

    xgboot.plot_importance(model, importance_type="cover")

3. Gain. The average training loss reduction gained when using a feature for splitting.

    xgboot.plot_importance(model, importance_type="gain")

## Common importance evaluation methods

### SHAP (SHapley Additive exPlanations)
A new individualized method that is both consistent and accurate. it shows not only importance of a feature but also show positiveness or negtiveness.
below is an example to show SHAP value of room feature.
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210302224136.png)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210302224221.png)
The shap Python package makes SHAP easier. We first call shap.TreeExplainer(model).shap_values(X) to explain every prediction, then call shap.summary_plot(shap_values, X) to plot these explanations

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201024232814.png)
#### explainer
1. deep
works for deep learning model, based on DeepLIFT algos
2. gradient

3. kernel
works for any model

4. linear
Linear model with independent and uncorrelated features

5. tree
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210302225711.png)

    import shap
    shap.initjs()
    X,y = shap.datasets.boston()
    model = xgboost.train({"learning_rate": 0.01}, xgboost.DMatrix(X, label=y), 100)
    #there are many explainer available, here use tree explainer for example
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)

6. sampling
based on hypothesis that feature independence

7. kerne

    #using kmeans
    X_train_summary = shap.kmeans(X_train, 10)
    t0 = time.time()
    explainerKNN = shap.KernelExplainer(knn.predict, X_train_summary)
    shap_values_KNN_train = explainerKNN.shap_values(X_train)
    shap_values_KNN_test = explainerKNN.shap_values(X_test)
    timeit=time.time()-t0
    timeit

#### visualization

##### Local Interper
1. single prediction
display contribution of each feature for one prediction

    shap.force_plot(explainer.expected_value, shap_values[0,:], X.iloc[0,:])

2. multi predictions

    shap.force_plot(explainer.expected_value, shap_values, X)

##### Global Interper
explanation of the overall structure of the model

1. summary_plot
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201024232517.png)

    #summarize the effects of all the features
    shap.summary_plot(shap_values, X)

2. Feature Importance

    shap.summary_plot(shap_values, X, plot_type="bar")

3. Interaction Values
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201024235048.png)

    shap_interaction_values = explainer.shap_interaction_values(X)
    shap.summary_plot(shap_interaction_values, X)

4. dependence_plot
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201024235212.png)

    #create a SHAP dependence plot to show the effect of a single feature across the whole dataset  
    shap.dependence_plot("RM", shap_values, X)
5. permutation importance
https://github.com/Qiuyan918/Permutation_Importance_Experiment

##### visualization of network
1. Networkx
non interactive visualization of Graph

    import networkx as nx
    G = nx.from_pandas_edgelist(df, source='Source', target='Target',edge_attr='weight')

the network can be visualized with following functions.
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210223010521.png)

2. PyVis
interactive visualization of network Graph

    from pyvis.network import Network
    net=Network(notebook=True)
    net.from_nx(G)
    net.show("test.html")

3. visdcc in dash

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210223011132.png)


### Saabas. 
An individualized heuristic feature attribution method.
### mean(|Tree SHAP|). 
A global attribution method based on the average magnitude of the individualized Tree SHAP attributions.
### Gain. 
The same method used above in XGBoost, and also equivalent to the Gini importance measure used in scikit-learn tree models.
### Split count. 
Represents both the closely related “weight” and “cover” methods in XGBoost, but is computed using the “weight” method.
### Permutation. 
The resulting drop in accuracy of the model when a single feature is randomly permuted in the test data set.

    * train model on dataset A
    * test model on dataset B, get MSE and loglos
    * random permute one feature in dataset B, and test again. the difference of scores between 2 and 3 is permutation importance


