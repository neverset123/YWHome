---
layout:     post
title:      feature engineering
subtitle:   
date:       2021-09-19
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - feature engineering
---

### 数据转换成图像

### 元数据泄露
当处理过的特征在没有应用任何机器学习的情况下，可以非常完美地解释目标时，这可能发生了数据泄露

### 表征学习特征

法直接从训练数据中捕捉最显著的特征，无需其他特征工程。
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210919231721.png)

### 均值编码
数据分析中经常会遇到类别属性，比如日期、性别、街区编号、IP地址等。绝大部分数据分析算法是无法直接处理这类变量的，需要先把它们先处理成数值型量。如果这些变量的可能值很少，我们可以用常规的one-hot编码和label encoding。但是，如果这些变量的可能值很多, 均值编码是最好的选择之一。但它也有缺点，就是容易过拟合（因为提供了大量数据），所以使用时要配合适当的正则化技术。

### 转换目标变量
对高度偏斜的数据，如果我们把目标变量转成log(1+目标)格式，那么它的分布就接近高斯分布了




