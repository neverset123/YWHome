---
layout:     post
title:      ml predictor
subtitle:   
date:       2020-12-27
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

systematically select the best subset of input features for model training to predict the target variable

## feature selection
* Embedded methods:  built-in into the model training phase of a classification or regression model
* Filter methods: check the intrinsic properties of features and use statistical techniques to evaluate the relationship between a predictor and the target variable
* Wrapper methods:  utilize ML algorithms as part of the feature evaluation process to identify and select the best subset of features iteratively and according to a specific performance metric

### filter feature selection
there are currently no widely used and supported python packages out there that support these advanced multivariate feature selection techniques
#### Categorical Feature Selection
scikit-learn’s SelectKBest class is used in conjunction with either the chi2 or mutual_info_classif functions to identify and select the top k most relevant features
* Chi-Squared Test of Independence
* Mutual Information    

        # import all the required libraries
        import pandas as pd
        from sklearn.model_selection import train_test_split
        from sklearn.preprocessing import LabelEncoder
        from sklearn.linear_model import LogisticRegression
        from sklearn.metrics import accuracy_score
        from scipy.stats import chi2_contingency

        # load the dataset
        dataset = pd.read_csv('abc.csv')
        # split into input and output variables
        X = dataset.iloc[:, :-1]
        y = dataset.iloc[:,-1]

        # assuming no mising values in dataset

        # split into train and test sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=1)

        # define an empty dictionary to store chi-test results
        chi2_check = {}
        # loop over each column in the encoded training set to calculate chi statistic with the target variable
        for column in X_train:
            chi, p, dof, ex = chi2_contingency(pd.crosstab(y_train, X_train[column]))
            chi2_check.setdefault('Feature',[]).append(column)
            chi2_check.setdefault('p-value',[]).append(p)
        # convert the dictionary to a DF
        chi2_result = pd.DataFrame(data = chi2_check)
        # select the top 4 features based on lowest p values
        top4_chi2 = chi2_result.nsmallest(4, 'p-value')['Feature'].tolist()

        # filter out these shortlisted features into new DFs
        X_train_fs = X_train[top4_chi2]
        X_test_fs = X_test[top4_chi2]

        # convert to shortlisted feature DFs into dummy variables
        X_train_enc = pd.get_dummies(X_train_fs)
        X_test_enc = pd.get_dummies(X_test_fs)
        # reindex the dummied test set variables to make sure all the feature columns in the train set are also available in the test set
        X_test_enc = X_test_enc.reindex(labels=X_train_enc.columns, axis=1, fill_value=0)

        # instantiate the LabelEncoder class to transform target variable
        le = LabelEncoder()
        # fit the LabelEncoder class on training set
        le.fit(y_train)
        # transform training and test target variables and convert to DFs
        y_train_enc = le.transform(y_train)
        y_test_enc = le.transform(y_test)

        # define classification algorithm
        model = LogisticRegression()
        # fit the model
        model.fit(X_train_enc, y_train_enc)
        # predict
        yhat = model.predict(X_test_enc)
        # evaluate predictions
        accuracy = accuracy_score(y_test_enc, yhat)
        print('Accuracy: %.2f' % (accuracy*100))

#### Numerical Feature Selection-Classification Problem
* ANOVA F-Statistic
* Mutual Information (as explained above)

        # import the required libraries
        import pandas as pd
        from sklearn.model_selection import RepeatedStratifiedKFold
        from sklearn.feature_selection import SelectKBest
        from sklearn.feature_selection import f_classif
        from sklearn.linear_model import LogisticRegression
        from sklearn.pipeline import Pipeline
        from sklearn.model_selection import GridSearchCV

        # load the dataset
        data = pd.read_csv('abc.csv')
        # split into input (X) and target (y) variables
        X = data.iloc[:, :-1]
        y = data.iloc[:,-1]

        # define the cross-validation evaluation method
        cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)

        # define the pipeline to evaluate
        model = LogisticRegression(max_iter = 1000)
        fs = SelectKBest(score_func = f_classif)
        pipeline = Pipeline(steps=[('anova', fs), ('lr', model)])

        # define the grid to use up to the max no. of features as the `k` value for `SelectKBest`
        grid = {}
        grid['anova__k'] = [i+1 for i in range(X.shape[1])]

        # define the grid search
        search = GridSearchCV(pipeline, grid, scoring='accuracy', n_jobs=-1, cv=cv)

        # perform the search
        results = search.fit(X, y)

        # summarize best score
        print('Best Mean Accuracy: %.3f' % results.best_score_)
        print('Best Config: %s' % results.best_params_)

#### Numerical Feature Selection — Regression Problem
* Correlation statistics
* Mutual Information (same as explained earlier, with just a different score_func to be used: mutual_info_regression)

        # import the required libraries
        import pandas as pd
        from sklearn.model_selection import RepeatedKFold
        from sklearn.feature_selection import SelectKBest
        from sklearn.feature_selection import f_regression # or mutual_info_regression, if desired
        from sklearn.linear_model import LinearRegression
        from sklearn.pipeline import Pipeline
        from sklearn.model_selection import GridSearchCV

        # load dataset
        data = pd.read_csv('abc.csv')
        X = data.iloc[:, :-1]
        y = data.iloc[:, -1]

        # define the evaluation method
        cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=1)

        # define the pipeline to evaluate
        model = LinearRegression()
        fs = SelectKBest(score_func = f_regression) # can also use mutual_info_regression to select based on Mutual Information
        pipeline = Pipeline(steps=[('feature',fs), ('lr', model)])

        # define the grid
        grid = {}
        grid['feature__k'] = [i for i in range(X.shape[1]-20, X.shape[1]+1)] # or replace with any desired range of `k` values to be tested

        # define the grid search
        search = GridSearchCV(pipeline, grid, scoring='neg_mean_absolute_error', n_jobs=-1, cv=cv)

        # perform the search
        results = search.fit(X, y)

        # summarize best
        print('Best MAE: %.3f' % results.best_score_)
        print('Best Config: %s' % results.best_params_)

### Wrapper Feature Selection
Recursive Feature Elimination (RFE) from scikit-learn is the most widely used wrapper feature selection method in practice

1) manual

    # import all required libraries
    import pandas as pd
    import numpy as np
    from sklearn.model_selection import cross_val_score
    from sklearn.model_selection import RepeatedStratifiedKFold
    from sklearn.feature_selection import RFE
    from sklearn.tree import DecisionTreeClassifier
    from sklearn.pipeline import Pipeline

    # load dataset
    data = pd.read_csv('abc.csv')
    X = data.iloc[:, :-1]
    y = data.iloc[:, -1]

    # create a pipeline of a specific algorithm with different no. of features to be evaluated
    models = {}
    for i in range (2, 10): # loop over a number of features to be used in RFE
        FS = RFE(estimator=DecisionTreeClassifier(), n_features_to_select = i)
        DTC = DecisionTreeClassifier()
        models[str(i)] = Pipeline(steps = [('features', FS), ('DT model', DTC)])

    # evaluate all the models using CV
    results = []
    names = []
    for name, model in models.items():
        cv = RepeatedStratifiedKFold(n_splits = 10, n_repeats = 3, random_state = 1)
        scores = cross_val_score(model, X, y, scoring = 'accuracy', cv = cv, n_jobs = -1)
        results.append(scores)
        names.append(name)
        print('>%s: %.3f' % (name, np.mean(scores)))

2) automatic feature selection

    # import all the required libraries
    import pandas as pd
    import numpy as np
    from sklearn.datasets import make_classification
    from sklearn.model_selection import cross_val_score, RepeatedStratifiedKFold
    from sklearn.feature_selection import RFECV
    from sklearn.linear_model import LogisticRegression
    from sklearn.tree import DecisionTreeClassifier
    from sklearn.ensemble import RandomForestClassifier
    import xgboost as xgb
    from xgboost.sklearn import XGBClassifier
    from sklearn.pipeline import Pipeline

    # load dataset
    data = pd.read_csv('abc.csv')
    X = data.iloc[:, :-1]
    y = data.iloc[:, -1]

    # create pipeline of differennt base algorithms to be used in RFECV (no. of features will be auto-selected based on cv in RFECV)
    models = {}
    # logistic regression
    rfecv = RFECV(estimator = LogisticRegression(), cv = 10, scoring = 'accuracy')
    model = DecisionTreeClassifier()
    models['LR'] = Pipeline(steps = [('features', rfecv), ('model', model)])
    # decision tree
    rfecv = RFECV(estimator = DecisionTreeClassifier(), cv = 10, scoring = 'accuracy')
    model = DecisionTreeClassifier()
    models['DT'] = Pipeline(steps = [('features', rfe), ('model', model)])
    # random forest
    rfecv = RFECV(estimator = RandomForestClassifier(), cv = 10, scoring = 'accuracy')
    model = DecisionTreeClassifier()
    models['RF'] = Pipeline(steps = [('features', rfe), ('model', model)])
    # XGBoost Classifier
    rfecv = RFECV(estimator=XGBClassifier(), cv = 10, scoring = 'accuracy')
    model = DecisionTreeClassifier()
    models['XGB'] = Pipeline(steps = [('features', rfecv), ('model', model)])

    # evaluate all the models
    results = []
    names = []
    for name, model in models.items():
        cv = RepeatedStratifiedKFold(n_splits = 10, n_repeats = 3, random_state = 1)
        scores = cross_val_score(model, X, y, scoring = 'accuracy', cv = cv, n_jobs = -1)
        results.append(scores)
        names.append(name)
        print('>%s: %.3f' % (name, np.mean(scores)))
    
    # create pipeline
    rfecv = RFECV(estimator = LogisticRegression(), cv = 10, scoring = 
        'accuracy')
    model = DecisionTreeClassifier()
    pipeline = Pipeline(steps=[('features', rfecv), ('model', model)])
    # fit the model on all available data
    pipeline.fit(X, y)
    # make a prediction for one example
    data = #load or define any new data unseen data that you want to make predictions upon
    yhat = pipeline.predict(data)
    print('Predicted: %.3f' % (yhat))