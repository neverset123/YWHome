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
* the result would not be unique and you’ll get different results on every run


    from sklearn.manifold import TSNE
    tsne = TSNE(n_components=2,perplexity=40, random_state=42)
    X_reduced_tsne = tsne.fit_transform(X)
    plt.scatter(X_reduced_tsne[:,0], X_reduced_tsne[:,1],c=vectorizer(y))
### visualize feature vectors

    # Create a two dimensional t-SNE projection of the embeddings
    tsne = TSNE(2, verbose=1)
    tsne_proj = tsne.fit_transform(test_embeddings)
    # Plot those points as a scatter plot and label them based on the pred labels
    cmap = cm.get_cmap('tab20')
    fig, ax = plt.subplots(figsize=(8,8))
    num_categories = 10
    for lab in range(num_categories):
        indices = test_predictions==lab
        ax.scatter(tsne_proj[indices,0],tsne_proj[indices,1], c=np.array(cmap(lab)).reshape(1,4), label = lab ,alpha=0.5)
    ax.legend(fontsize='large', markerscale=2)
    plt.show()
    
    # three dimensional t-sne projection of the embeddings
    tsne = TSNE(3, verbose=1)
    tsne_proj = tsne.fit_transform(test_embeddings)
    cmap = cm.get_cmap('tab20')
    num_categories = 10
    for lab in range(num_categories):
        indices = test_predictions == lab
        ax.scatter(tsne_proj[indices, 0],
                tsne_proj[indices, 1],
                tsne_proj[indices, 2],
                c=np.array(cmap(lab)).reshape(1, 4),
                label=lab,
                alpha=0.5)
    ax.legend(fontsize='large', markerscale=2)
    plt.show()

## PCA
used to simplify a large and complex dataset into a smaller, more easily understandable dataset.

    pca = PCA(n_components=2)
    pca.fit(test_embeddings)
    pca_proj = pca.transform(test_embeddings)
    pca.explained_variance_ratio_
    # explained_variance_ratio_ indicate the amount of variance from your data that the principal components capture, the higher the better
    # array([0.16178058, 0.08613876], dtype=float32)