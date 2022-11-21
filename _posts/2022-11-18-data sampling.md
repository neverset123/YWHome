---
layout:     post
title:      data sampling
subtitle:   
date:       2022-11-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

## SMOTE
MOTE oversamples by synthesizing new samples that are close in distance to existing ones within the same class.
```
from imblearn.over_sampling import SMOTE

smote = SMOTE() # initializing
X_train, y_train = smote.fit_sample(X_train, y_train)
```

