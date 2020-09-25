---
layout:     post
title:      python visualization
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## Plotly Express
By default, all of the Plotly visualizations are interactive

### basic functions

    import plotly.express as px
    px.scatter()
    px.line()
    px.bar()
    px.histogram()
    px.box()
    px.violin()
    px.strip()

### many chart types

    fig = px.treemap()
    fig = px.sunburst(
    #to save image
    fig.write_image()
    #save to html
    fig.write_html()

### integrate with pandas

    pd.options.plotting.backend = "plotly"
    fig = df[['sodium', 'potass']].plot(kind='hist',
                                    nbins=50,
                                    histnorm='probability density',
                                    opacity=0.75,
                                    marginal='box',
                                    title='Potassium and Sodium Distributions')
    fig.write_image('potassium_sodium_plots.png')

### Interactive options
#### Dash

#### Streamlit
streamlit run streamlit_example.py

    #streamlit_example.py
    import streamlit as st
    import pandas as pd
    import plotly.express as px


    @st.cache()
    def load_data():
        df = pd.read_csv(
            'https://github.com/chris1610/pbpython/blob/master/data/cereal_data.csv?raw=True'
        )
        return df


    # Read in the cereal data
    df = load_data()

    st.title('Rating exploration')

    # Only a subset of options make sense
    x_options = [
        'calories', 'protein', 'fat', 'sodium', 'fiber', 'carbo', 'sugars',
        'potass'
    ]

    # Allow use to choose
    x_axis = st.sidebar.selectbox('Which value do you want to explore?', x_options)

    # plot the value
    fig = px.scatter(df,
                    x=x_axis,
                    y='rating',
                    hover_name='name',
                    title=f'Cereal ratings vs. {x_axis}')

    st.plotly_chart(fig)