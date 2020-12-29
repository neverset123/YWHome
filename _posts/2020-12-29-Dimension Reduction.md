---
layout:     post
title:      dimension reduction
subtitle:   
date:       2020-12-29
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---


## Linear Algebra Methods
* Matrix factorization methods
* Principal Components Analysis

        # evaluate pca with logistic regression algorithm for classification
        from numpy import mean
        from numpy import std
        from sklearn.datasets import make_classification
        from sklearn.model_selection import cross_val_score
        from sklearn.model_selection import RepeatedStratifiedKFold
        from sklearn.pipeline import Pipeline
        from sklearn.decomposition import PCA
        from sklearn.linear_model import LogisticRegression
        # define dataset
        X, y = make_classification(n_samples=1000, n_features=20, n_informative=10, n_redundant=10, random_state=7)
        # define the pipeline
        steps = [('pca', PCA(n_components=10)), ('m', LogisticRegression())]
        model = Pipeline(steps=steps)
        # evaluate model
        cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)
        n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
        # report performance
        print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

* Singular Value Decomposition

        # evaluate svd with logistic regression algorithm for classification
        from numpy import mean
        from numpy import std
        from sklearn.datasets import make_classification
        from sklearn.model_selection import cross_val_score
        from sklearn.model_selection import RepeatedStratifiedKFold
        from sklearn.pipeline import Pipeline
        from sklearn.decomposition import TruncatedSVD
        from sklearn.linear_model import LogisticRegression
        # define dataset
        X, y = make_classification(n_samples=1000, n_features=20, n_informative=10, n_redundant=10, random_state=7)
        # define the pipeline
        steps = [('svd', TruncatedSVD(n_components=10)), ('m', LogisticRegression())]
        model = Pipeline(steps=steps)
        # evaluate model
        cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)
        n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
        # report performance
        print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

* Non-Negative Matrix Factorization
* Linear Discriminant Analysis

        # evaluate lda with logistic regression algorithm for classification
        from numpy import mean
        from numpy import std
        from sklearn.datasets import make_classification
        from sklearn.model_selection import cross_val_score
        from sklearn.model_selection import RepeatedStratifiedKFold
        from sklearn.pipeline import Pipeline
        from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
        from sklearn.linear_model import LogisticRegression
        # define dataset
        X, y = make_classification(n_samples=1000, n_features=20, n_informative=10, n_redundant=10, random_state=7)
        # define the pipeline
        steps = [('lda', LinearDiscriminantAnalysis(n_components=1)), ('m', LogisticRegression())]
        model = Pipeline(steps=steps)
        # evaluate model
        cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)
        n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
        # report performance
        print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

## Manifold Learning Methods
* Isomap Embedding

        # define the pipeline
        steps = [('iso', Isomap(n_components=10)), ('m', LogisticRegression())]
        model = Pipeline(steps=steps)

* Locally Linear Embedding

    # define the pipeline
    steps = [('lle', LocallyLinearEmbedding(n_components=10)), ('m', LogisticRegression())]
    model = Pipeline(steps=steps)

* Multidimensional Scaling
* Spectral Embedding
* t-distributed Stochastic Neighbor Embedding
