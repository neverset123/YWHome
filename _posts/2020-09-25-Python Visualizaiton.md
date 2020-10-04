---
layout:     post
title:      python visualization
subtitle:   
date:       2020-09-25
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

## Datapane
Datapane is an API allow people to view visualization result and share result easily in the cloud.Deploying Python scripts and notebooks is also possible.  
It supports:
* Pandas  
* Plots from Python visualization libraries such as Plotly, Bokeh, Altair, and Folium
* Markdown
To install

    pip3 install datapane
    #generate report you need token
    datapane login --server=https://datapane.com/ --token=yourtoken

### generate report

    import pandas as pd
    import altair as alt
    import datapane as dp
    df = pd.read_csv('https://query1.finance.yahoo.com/v7/finance/download/GOOG?period2=1585222905&interval=1mo&events=history')
    chart = alt.Chart(df).encode(
        x='Date:T',
        y='Open'
    ).mark_line().interactive()
    #generate report
    r = dp.Report(
    dp.Markdown('My simple report'), #add description to the report
    dp.Table(df), #create a table
    dp.Plot(chart) #create a chart
    )

    # Publish your report. Make sure to have visibility='PUBLIC' if you want to share your report
    r.publish(name='stock_report', visibility='PUBLIC')
        
### add interactive parameter in report 

    datapane script deploy --script=<your_python_script.py> --name=name_of_your_report