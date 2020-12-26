---
layout:     post
title:      clustering
subtitle:   
date:       2020-12-27
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - clustering
---

## tSNE
tSNE is the t-distributed stochastic neighborhood embedding
* PCA works by preserving the variability of the data; tSENE works by non-linear probility
* PCA focusses on global structure rather than local, tSNE focuses on local
* tSNE is computationally more expensive than PCA
* PCA intuition is simpler and has fewer parameters than tSNE, as a result, has wider applicability


    from sklearn.manifold import TSNE
    tsne = TSNE(n_components=2,perplexity=40, random_state=42)
    X_reduced_tsne = tsne.fit_transform(X)
    plt.scatter(X_reduced_tsne[:,0], X_reduced_tsne[:,1],c=vectorizer(y))