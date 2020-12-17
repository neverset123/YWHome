---
layout:     post
title:      real time computation
subtitle:   
date:       2020-09-30
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## Dashboard
### Plotly
Plotly allows you to make interactive figures in just a few lines of code using either Python or JavaScript. Plotly plots are all generated from JSONs being interpreted by d3

    import plotly.graph_objects as go
    from plotly.subplots import make_subplots
    import pandas as pd
    import requests
    from datetime import datetime

    raw= requests.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=1%3D1&outFields=*&outSR=4326&f=json")
    raw_json = raw.json()
    df = pd.DataFrame(raw_json["features"])

    data_list = df["attributes"].tolist()
    df_final = pd.DataFrame(data_list)
    df_final.set_index("OBJECTID")
    df_final = df_final[["Country_Region", "Province_State", "Lat", "Long_", "Confirmed", "Deaths", "Recovered", "Last_Update"]]

    def convertTime(t):
        t = int(t)
        return datetime.fromtimestamp(t)

    df_final = df_final.dropna(subset=["Last_Update"])
    df_final["Province_State"].fillna(value="", inplace=True)

    df_final["Last_Update"]= df_final["Last_Update"]/1000
    df_final["Last_Update"] = df_final["Last_Update"].apply(convertTime)

    df_total = df_final.groupby("Country_Region", as_index=False).agg(
        {
            "Confirmed" : "sum",
            "Deaths" : "sum",
            "Recovered" : "sum"
        }
    )

    total_confirmed = df_final["Confirmed"].sum()
    total_recovered = df_final["Recovered"].sum()
    total_deaths = df_final["Deaths"].sum()

    df_top10 = df_total.nlargest(10, "Confirmed")
    top10_countries_1 = df_top10["Country_Region"].tolist()
    top10_confirmed = df_top10["Confirmed"].tolist()

    df_top10 = df_total.nlargest(10, "Recovered")
    top10_countries_2 = df_top10["Country_Region"].tolist()
    top10_recovered = df_top10["Recovered"].tolist()

    df_top10 = df_total.nlargest(10, "Deaths")
    top10_countries_3 = df_top10["Country_Region"].tolist()
    top10_deaths = df_top10["Deaths"].tolist()

    fig = make_subplots(
        rows = 4, cols = 6,

        specs=[
                [{"type": "scattergeo", "rowspan": 4, "colspan": 3}, None, None, {"type": "indicator"}, {"type": "indicator"}, {"type": "indicator"} ],
                [    None, None, None,               {"type": "bar", "colspan":3}, None, None],
                [    None, None, None,              {"type": "bar", "colspan":3}, None, None],
                [    None, None, None,               {"type": "bar", "colspan":3}, None, None],
            ]
    )


    message = df_final["Country_Region"] + " " + df_final["Province_State"] + "<br>"
    message += "Confirmed: " + df_final["Confirmed"].astype(str) + "<br>"
    message += "Deaths: " + df_final["Deaths"].astype(str) + "<br>"
    message += "Recovered: " + df_final["Recovered"].astype(str) + "<br>"
    message += "Last updated: " + df_final["Last_Update"].astype(str)
    df_final["text"] = message

    fig.add_trace(
        go.Scattergeo(
            locationmode = "country names",
            lon = df_final["Long_"],
            lat = df_final["Lat"],
            hovertext = df_final["text"],
            showlegend=False,
            marker = dict(
                size = 10,
                opacity = 0.8,
                reversescale = True,
                autocolorscale = True,
                symbol = 'square',
                line = dict(
                    width=1,
                    color='rgba(102, 102, 102)'
                ),
                cmin = 0,
                color = df_final['Confirmed'],
                cmax = df_final['Confirmed'].max(),
                colorbar_title="Confirmed Cases<br>Latest Update",  
                colorbar_x = -0.05
            )

        ),
        
        row=1, col=1
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=total_confirmed,
            title="Confirmed Cases",
        ),
        row=1, col=4
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=total_recovered,
            title="Recovered Cases",
        ),
        row=1, col=5
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=total_deaths,
            title="Deaths Cases",
        ),
        row=1, col=6
    )

    fig.add_trace(
        go.Bar(
            x=top10_countries_1,
            y=top10_confirmed, 
            name= "Confirmed Cases",
            marker=dict(color="Yellow"), 
            showlegend=True,
        ),
        row=2, col=4
    )

    fig.add_trace(
        go.Bar(
            x=top10_countries_2,
            y=top10_recovered, 
            name= "Recovered Cases",
            marker=dict(color="Green"), 
            showlegend=True),
        row=3, col=4
    )

    fig.add_trace(
        go.Bar(
            x=top10_countries_3,
            y=top10_deaths, 
            name= "Deaths Cases",
            marker=dict(color="crimson"), 
            showlegend=True),
        row=4, col=4
    )


    fig.update_layout(
        template="plotly_dark",
        title = "Global COVID-19 Cases (Last Updated: " + str(df_final["Last_Update"][0]) + ")",
        showlegend=True,
        legend_orientation="h",
        legend=dict(x=0.65, y=0.8),
        geo = dict(
                projection_type="orthographic",
                showcoastlines=True,
                landcolor="white", 
                showland= True,
                showocean = True,
                lakecolor="LightBlue"
        ),

        annotations=[
            dict(
                text="Source: https://bit.ly/3aEzxjK",
                showarrow=False,
                xref="paper",
                yref="paper",
                x=0.35,
                y=0)
        ]
    )

    fig.write_html('first_figure.html', auto_open=True)

#### creating html app

    #jsonify python trace
    data = json.dumps(plot_data, cls=plotly.utils.plotlyJSONEncoder)
    layout = json.dumps(plot_layout, cls=plotly.utils.plotlyJSONEncoder)
    #integrate json into htlm wtih jinja
    <script>
    Plotly.newPlot("myPlot", {{data | safe}}, {{layout | safe}})
    </script>

    #instead of create trace and layout we can simply generate fig object to be passed to html
    def create_plot_express():
        data = load_data()
        fig = px.line(
            x=[d["date"] for d in data],
            y=[d["total_tests"] for d in data]
        )
        
        return json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)

    #integrate with html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
        Index
        <div id="myPlot"></div>
    </body>
    <script>
        Plotly.newPlot("myPlot", {{ fig | safe }})
    </script>
    </html>

## Deployment Platform 
### Heroku
a platform-as-a-service (PaaS) for deploying and hosting web applications. Dynos provides virtualized linux resources (ram, cpu and linux etc.). The free version gets you one dyno with up to 500MB storage and 500MB ram. It sleeps after 30 minutes of inactivity, presumably so Heroku resources are not drained
steps needed for deployment:

1) Dash app running on localhost
2) Install Git
3) Setup GitHub account (+ recommend install GitHub Desktop)
4) Setup Heroku account (+ install the command line interface)
5) Add dependencies and special files (i.e. install and import Gunicorn, create Procfile and runtime.txt)
6) Clone repo from GitHub to local machine (only once)
7) Create Heroku app linked to your repo (only once, ref deployment guides, Heroku CLI)
8) Commit and push your code changes to GitHub repo (repetitively)
9) Deploy/Re-deploy Heroku app by pushing changes from Heroku CLI (“git push Heroku main”)

    heroku login
    git init
    heroku create your-app-name
    git add .
    git commit -m "Your customized message"
    git push heroku main

#### extra tips for heroku
##### Procfile
let Heroku know how to handle web processes (in our case using Gunicorn HTTP server) and the name of your Python application. Typically it contains lines:

    web: gunicorn app:server

##### runtime.txt
tells Heroku which Python runtime to use. Typically it constains lines:

    python-3.7.8

##### useful heroku command

1) to view deployment logs

    heroku logs --tail

2) display current apps

    heroku apps

3) Display current dynos

    heroku ps
    heroku psheroku ps -a <yourapp>

4) Run bash terminal

    heroku run bash -a <yourapp>

5) Restart dynos

    heroku dyno:restart

6) Add additional log metrics

    heroku labs:enable log-runtime-metrics

7) Add runtime metrics to log

    heroku labs:enable log-runtime-metrics

8) set web concurrency

    heroku config:set WEB_CONCURRENCY=3
    heroku config:set WEB_CONCURRENCY=3 -a <herokuappname>

##### problem with heroku
1) heroku does not serve static files(Any images, documents, video, audio). 
solution could be to use WhiteNoise library

    from whitenoise import WhiteNoise
    server = app.server
    #folder to be static files must be named as static
    server.wsgi_app = WhiteNoise(server.wsgi_app, root=‘static/’)

2) Heroku’s file system is ephemeral or transient, any new files created at runtime will disappear after a few days.

3) Heroku is file extension case-sensitive

    