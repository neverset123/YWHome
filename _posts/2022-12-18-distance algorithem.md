---
layout:     post
title:      distance algorithem
subtitle:   
date:       2022-12-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

## Euclidean distance
drawback: 
1. does not fit for demonsion higher than 3d
2. different features have different units, cannot be standarized.

```
 from scipy.spatial import distance
 distance.euclidean(vector_1, vector_2)
```

## Manhattan distance
calculated based on the fact that a person can only move at rectangular angles, drawback:
1. not as intuitive as Euclidean distance
2. may be not shortest distance

```
from scipy.spatial import distance
distance.cityblock(vector_1, vector_2)
```

## Chebyshev distance
the maximum distance in any dimension between two real-valued vectors

```
 from scipy.spatial import distance
 distance.chebyshev(vector_1, vector_2)
```

## Minkowski distance
a generalized form of the all the above distance metrics

```
 from scipy.spatial import distance
 distance.minkowski(vector_1, vector_2, p)
```

## Cosine similarity
drawback:
1. calculated only angle difference not length differnce

```
from scipy.spatial import distance
distance.cosine(vector_1, vector_2)
```

## Haversine distance
calculated the shortest distance between two points on a sphere

```
 from sklearn.metrics.pairwise import haversine_distances
 haversine_distances([vector_1, vector_2])
```

## Hamming distance
Compare vectors element-wise and average the number of differences. If the two vectors are the same, the resulting distance is between 0, and if the two vectors are completely different, the resulting distance is 1.
drawback:
1. only compare vectors of the same length
2. it cannot give the magnitude of the difference
```
 from scipy.spatial import distance
 distance.hamming(vector_1, vector_2)
```

## Jaccard Index
Jaccard index is used to determine the similarity between two sample sets. It reflects how many one-to-one matches exist compared to the entire dataset. The Jaccard index is often used to compare the predictions of deep learning models on binary data such as image recognition with labeled data, or to compare text patterns in documents based on word overlap.
drawback: 
1. depend on the dataset size
```
 from scipy.spatial import distance
 distance.jaccard(vector_1, vector_2)
```

## Sorensen-Dice
calculate overlap percentage to measure dataset similarity, used for image segmentation and text similarity analysis.
drawback: depend on dataset size
```
 from scipy.spatial import distance
 distance.dice(vector_1, vector_2)
```

## Dynamic Time Warping
measuring the distance between two time series of different lengths. Can be used for all time series data use cases such as speech recognition or anomaly detection. using many-to-one or one-to-many mappings to minimize the total distance between two time series. This results in a more intuitive measure of similarity when searching for the best alignment.
drawback:
1. high computation cost

```
 from scipy.spatial.distance import euclidean
 from fastdtw import fastdtw
 distance, path = fastdtw(timeseries_1, timeseries_2, dist=euclidean)
```

