---
layout:     post
title:      streamlit
subtitle:   
date:       2020-10-24
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

Streamlit is the first application development framework specifically for machine learning and data science teams. It is the fastest way to develop custom machine learning tools.

    $ pip install --upgrade streamlit 
    $ streamlit hello  

## UI

    import streamlit as st
    x = st.slider('x')
    st.write(x, 'squared is', x * x)

## cache

    import streamlit as st
    import pandas as pd
    #Reuse this data across runs!
    read_and_cache_csv = st.cache(pd.read_csv)
    BUCKET = "https://streamlit-self-driving.s3-us-west-2.amazonaws.com/"
    data = read_and_cache_csv(BUCKET + "labels.csv.gz", nrows=1000)
    desired_label = st.selectbox('Filter to:', ['car', 'truck'])
    st.write(data[data.label == desired_label])

## example
The Streamlit application example allows you to perform semantic search in the entire Udacity self-driving vehicle photo data set, visualize manual annotation, and run a YOLO target detector in real time

    $ pip install --upgrade streamlit opencv-python
    $ streamlit run https://raw.githubusercontent.com/streamlit/demo-self-driving/master/app.py