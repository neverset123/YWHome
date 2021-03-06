---
layout:     post
title:      model reliability
subtitle:   
date:       2021-03-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---



## Lime
https://github.com/marcotcr/lime

## LRP
https://github.com/sebastian-lapuschkin/lrp_toolbox

## plausibility checks by exploiting hierarchy of labels
Probability score is not reliable on unseen data, a second model to check label information could help increase plausibility. The original model is trained on our target labels as they are on the highest granularity (leafs in the label hierarchy). The plausibility model is trained on a higher-level label (parent nodes or related nodes in the graph). 
a good example is the animal classifier example that the original model is trained on the breed of animals and has 1000 different labels, while the plausibility model is trained to classify the 50 different animals in the data.


 
