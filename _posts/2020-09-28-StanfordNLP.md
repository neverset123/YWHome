---
layout:     post
title:      standfordNLP
subtitle:   
date:       2020-09-25
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - NLP
---

CoreNLP is a library supporting all NLP operations like stemming, lementing, tokenization, finding parts of speech, sentiment analysis. StanfordNLP is a python wrapper for CoreNLP.

## Installation

    pip install stanfordnlp

## Usage example

    import stanfordnlp as st
    st.download(‘en’) 
    pipe = stanfordnlp.Pipeline()
    text = pipe("test text")