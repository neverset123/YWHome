---
layout:     post
title:      googlechart
subtitle:   
date:       2021-04-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - visualization
---


## googlechart
### flask app to load data into html

    from flask import Flask
    from flask import render_template

    import pandas as pd
    import json


    app = Flask(__name__)

    @app.route('/')
    def weather():
        
        url = 'london2018.csv'
        weather = pd.read_csv(url)

        title = "Monthly Max and Min Temperature"
        temps = weather[['Month','Tmax','Tmin']]
        temps['Month'] = temps['Month'].astype(str)
        temps['Avg'] = (temps['Tmax']+temps['Tmin'])/2
        
        d = temps.values.tolist()
        c = temps.columns.tolist()
        d.insert(0,c)

        tempdata = json.dumps({'title':title,'data':d})
        
        return render_template('weather.html', tempdata=tempdata)

### template html to display data       
to further intergrate this html with plotly interactive html you can insert this html to plotly html with iframe, e.g. 	<iframe width=420 height=330 frameborder=0 scrolling=false src="googlechart.html"></iframe>

    <!DOCTYPE html>
    <html>
    <head>
        <!-- <script>
        data = [
            ["Car","Number"],
            ["Audi", 3],
            ["BMW", 2],
            ["Mercedes", 1],
            ["Opel", 3],
            ["Volkswagen", 4]
        ];
        chartType = "ColumnChart";
        containerId = "chart1";
        options = {"title":"Cars parked in my road"};
        </script>
        <script src="https://www.gstatic.com/charts/loader.js">   
        </script> -->
        <script>
        tdata = JSON.parse({{tempdata|tojson|safe}});
        tempdata = tdata.data;
        temptitle = tdata.title;
        chartType = "LineChart";
        containerId = "chart1";
        options = {"title":temptitle};
        </script>
        <script>
        // Load the Visualization API and the corechart package
        google.charts.load('current', {'packages':['corechart']});
        // Set a callback for when the API is loaded
        google.charts.setOnLoadCallback(drawChart);
        
        // This is the callback function which actually draws the chart
        function drawChart(){
            google.visualization.drawChart({
            "containerId": containerId,
            "dataTable": data,
            "chartType": chartType,
            "options": options
            });
        }
        </script>
    </head>
    <body>
        <div style="width:600px; height:300px" id="chart1"></div>
    </body>
    </html>

