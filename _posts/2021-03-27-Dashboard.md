---
layout:     post
title:      dashboard
subtitle:   
date:       2021-03-27
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## echarts
### pyecharts
combine python and echarts to create beautiful charts
### dash_echarts
combine dash and echarts to create dashboad(https://github.com/mergeforward/dash_echarts)

    #installation
    #pip install 'dash_echarts[play]'
    app = dash.Dash("My fisrt dash app with ECharts!")
    app.run_server(debug=True)

#### line chart

    import dash_echarts
    import dash
    import dash_html_components as html


    if __name__ == '__main__':
        app = dash.Dash("My fisrt dash app with ECharts!")

        option = {
            "xAxis": {
                "type": "category",
                "data": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            },
            "yAxis": {
                "type": "value"
            },
            "series": [{
                "data": [820, 932, 901, 934, 1290, 1330, 1320],
                "type": "line",
                "smooth": True
            }]
        } 

        app.layout = html.Div([
            dash_echarts.DashECharts(
                option = option, id='echarts',
                style={
                    "width": '100vw',
                    "height": '100vh',
                }
            ),
        ])

        app.run_server(debug=True)