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
Plotly allows you to make interactive figures in just a few lines of code using either Python or JavaScript. figure in plotly is a JSON-like data structure with three main attributes: data, layout and frames. The frames attribute contains optional frames that are used in animations. You can either first write the entire figure structure using JSON or Python dictionaries and then instantiate the figure object, or create the figure object first and update figure attributes incrementally.  
Plotly supports “magic underscore notation” which means that there is no need to stepwise deepen into the object to access inner attributes but rather are able to access inner attributes directly
#### Index plot
##### get data

    # Imports
    import pandas as pd
    from ipywidgets import widgets as wg
    import yfinance as yf
    import plotly.graph_objects as go
    from plotly.offline import init_notebook_mode, iplot

    init_notebook_mode()

    tickers = ["FB", "AMZN", "DD", "BRK-A"]

    df = yf.download(
            tickers=tickers,
            period="3y",
            interval="1wk",
            group_by="column")
            
    df.head(5)

##### index chart with fixed reference dates

    #generalized function for indexed column
    def create_indexed_columns(date, df, top_level_name=""):
        """Returns indexed columns for given dataframe"""

        # find index of the date that is closest to our reference date
        closest_date_index = df.index.get_loc(date, method="nearest")

        # get the values in the initial columns for the reference date 
        reference_values = df.iloc[closest_date_index]['Adj Close']

        # divide initial columns by values at ref. date and store in intermediate df
        inter_df = df['Adj Close'].div(reference_values)*100 - 100

        # create a multindex for the intermediate df using the date as top-level index
        closest_date = df.index[closest_date_index]
        inter_df.columns = pd.MultiIndex.from_product(
                        [[top_level_name if top_level_name else str(closest_date)], inter_df.columns])
        
        return inter_df, closest_date

    #reference date
    ref_dict = {
        "Cambridge Analytica scandal": "2018-03-28",
        "DowDuPont separation":        "2019-04-15",
        "Corona stock market drop":    "2020-02-14"
    }

    #update reference date with closest date
    tmp_dict = {}
    fixed_df = df.copy()
    for ref_name, ref_date in ref_dict.items():
        # create intermediate df for reference date
        inter_df, closest_date = create_indexed_columns(ref_date, fixed_df, top_level_name=ref_name)
        
        fixed_df = fixed_df.join(inter_df)
        tmp_dict.update(
            {ref_name: dict(
                initial_date=ref_name,
                closest_date=closest_date)}
        )
    ref_dict.update(tmp_dict)
    
    #create plotly object
    ref_date_fig = go.Figure()
    # loop over reference dates
    for ref_name in ref_dict.keys():
        # loop over tickers for reference date
        for ticker in fixed_df[ref_name].columns:
            ref_date_fig.add_scatter(
                x=fixed_df.index,
                y=fixed_df[ref_name, ticker],
                name=ticker, 
                meta=dict(reference_date=ref_name)
            )
    ref_date_fig.show()

    #create visibility array
    def create_visibility_array(ref_date):
        """
        Returns array of boolean values representing the
        visibility array of figure traces. Traces with the 
        same meta value as 'ref_date' are set to 'True'.
        """

        return [True if trace['meta']['reference_date'] == ref_date 
                else False for trace in ref_date_fig['data']]
    
    #button for reference date selection
    def create_buttons():
        """Returns list of button objects."""
        
        button_list = []
        for ref_date in ref_dict.keys():
            ref_button = dict(
                label=ref_date, 
                method="restyle",
                args=[dict(
                    visible=create_visibility_array(ref_date))]
            )
            button_list.append(ref_button)
        return button_list

    #add button to figure
    ref_date_fig.update_layout(
        updatemenus=[dict(buttons=create_buttons())])
    # hide traces on initialization, by default all traces are shown
    ref_date_fig.update_traces(visible=False)
    ref_date_fig.update_traces(
        visible=True,
        selector=dict(meta={'reference_date': list(ref_dict.keys())[0]})
        )
    ref_date_fig.show()

    # add customized layout to a figure
    def style_plot(figure):
        """Provides basic layout attributes for given figure."""
        figure.update_layout(
            title=f"Relative growth of stock prices for {df.index[0].strftime('%B %Y')} - " \
                +                f"{df.index[-1].strftime('%B %Y')}",
            hovermode="x",
            # D3 formatting. Adds a percentage sign and rounds numbers
            # to 1 decimal after decimal point.
            yaxis1=dict(ticksuffix=" %", tickformat="+.1f", title="Relative growth"),
            #Setting the overlaying attribute to 'y' will force the traces that are defined with respect to the secondary y-axis to behave as if they were defined on the first y-axis. the combination of this attribute and fixedrange allows us to see the reference lines yet makes their scale independent of the y-axis.
            yaxis2=dict(
                fixedrange=True,
                overlaying="y",
                range=[0, 1],
                visible=False,
            ),
            xaxis=dict(title="Date")
        )

    style_plot(ref_date_fig)

    #create reference line
    def create_reference_line(x, name, meta=""):
        """Returns a dictionary that defines a 
        black line bound to the secondary yaxis.
        """

        ref_line = dict(
            x=[x, x],
            y=[0, 1],
            name=name,
            yaxis="y2",
            mode="lines",
            type="scatter",
            line=dict(
                color="black",
                width=0.5
            ),
            meta=meta
        )
        return ref_line

    #add reference line to figure
    for ref_key, ref_value in ref_dict.items():
        ref_date_fig.add_trace(go.Scatter(
            create_reference_line(
                x=ref_value['closest_date'],
                name=ref_value['closest_date'].strftime("%Y-%m-%d"), 
                meta=dict(reference_date=ref_key)
                )
            ))

    ref_date_fig.update_layout(
        updatemenus=[dict(buttons=create_buttons(), x=-0.12)])
    # hide traces on initialization, by default all traces are shown
    ref_date_fig.update_traces(visible=False)
    ref_date_fig.update_traces(
        visible=True,
        selector=dict(meta={'reference_date': list(ref_dict.keys())[0]})
        )
    ref_date_fig.show()
##### dynamic indexing chart

    # create copy of initial dataframe
    df = prepared_df.copy()
    def create_traces_for_date(date, df):
        """Indexes dataframe to given date and returns list of traces."""
        trace_list = []
        calculated_df, _ = create_indexed_columns(date, df)
        for trace in calculated_df.columns:
            datadict = dict(
                name=trace[1],
                type="scatter",
                x=calculated_df.index,
                y=calculated_df[trace],
                yaxis="y"
            )
            trace_list.append(datadict)
        reference_line = create_reference_line(
            x=date, name=date.strftime('%Y-%m-%d'))
        return trace_list + [reference_line]
    
    #create slider
    def make_initial_sliders_dict():
        """Generates a dictionary that describes the initial slider."""
        sliders_dict = dict(
            yanchor='top',
            xanchor='left',
            currentvalue=dict(
                font=dict(size=16),
                prefix='Current date: ',
                visible=True,
                xanchor='right'
            ),
            pad=dict(b=10, t=50),
            len=1,
            x=0,
            y=0,
            steps=[],
        )
        return sliders_dict

    #slider steps
    def create_slider_step(frame_name, redraw):
        """Generates a list of slider steps."""
        slider_step = dict(
            args=[[frame_name, frame_name], dict(
                frame=dict(duration=0, redraw=redraw),
                mode='immmediate',
                transition=dict(duration=0))
            ],
            label=frame_name,
            method='animate'
        )
        return slider_step

    # create slider step and frame for each step
    def make_steps_and_frames(df, redraw=False):
        """Generates a list of steps and a list of frames for given df."""

        slider_step_list, frame_list = [], []
        for date in df.index:
            datestring = date.strftime('%Y-%m-%d')
            frame = dict(
                data=create_traces_for_date(date, df),
                name=datestring)
            frame_list.append(frame)
            step = create_slider_step(datestring, redraw)
            slider_step_list.append(step)

        return slider_step_list, frame_list

    #make dynamic index plot
    def make_dynamic_index_chart(df, redraw=False):
        """Creates the entire dynamic index chart."""

        slider_step_list, frame_list = make_steps_and_frames(df, redraw)
        
        sliders_dict = make_initial_sliders_dict()
        sliders_dict['steps'] = slider_step_list

        new_fig = go.Figure(data=frame_list[0]['data'], frames=frame_list)
        new_fig.update_layout(sliders=[sliders_dict])
        style_plot(new_fig)
        return new_fig

    new_fig = make_dynamic_index_chart(df)
    new_fig.show()

##### Index chart with variable index in JupyterLab

    from IPython.display import display
    from ipywidgets import widgets as wg
    dfs = df.copy()

    #chart needs to be a FigureWidget object rather than a Figure object to be compatiable with jupyter widgets
    #create initial chart
    ref_date_fig = go.FigureWidget()
    style_plot(ref_date_fig)

    starting_date = dfs.index[0]
    inter_df, _ = create_indexed_columns(starting_date, dfs)
    for col in inter_df.loc[[starting_date]].columns:
        ref_date_fig.add_scatter(
            x=inter_df.index, 
            y=inter_df[col], 
            name=col[1])

    ref_date_fig.add_trace(go.Scatter(
        create_reference_line(
            starting_date, starting_date.strftime("%Y-%m-%d"),
            meta="reference line")))

    def update_chart(new_date):
        """Indexes dataframe to given date and updates the index chart figure."""
        tmp_df, closest_date = create_indexed_columns(new_date, dfs)
        with ref_date_fig.batch_update():
            closest_date_str = str(closest_date)
            # update all except last trace, because last trace is the reference line
            for d, col in zip(ref_date_fig.data[:-1], tmp_df[closest_date_str].columns):
                d.y = tmp_df[closest_date_str, col]
            # change position of the reference line
            ref_date_fig.data[-1]['x'] = [closest_date, closest_date]
            ref_date_fig.layout.title = f"Closest date: {closest_date_str[:10]}"

    #date picker and slider
    ref_date_picker = wg.DatePicker(value=starting_date, description='Index to:')
    def picker_response(change):
        """Updates chart on DatePicker widget change."""
        
        new_date = change['new'].isoformat()
        update_chart(new_date)
    ref_date_picker.observe(picker_response, names='value')
    # only works in JupyterLab !
    display(wg.VBox([
        wg.HBox([ref_date_picker]),
        ref_date_fig])
        )

    #use slider
    pd.to_datetime(dfs.index)
    ref_slider = wg.SelectionSlider(
        options=[d.strftime("%Y-%m-%d") for d in list(dfs.index)],
        description='Index to:',
        continuous_update=False
    )


    def slider_response(change):
        """Updates chart on slider change."""

        new_date = change['new']
        update_chart(new_date)


    ref_slider.observe(slider_response, names='value')

    # only works in JupyterLab !
    display(wg.VBox([
        wg.HBox([ref_slider]),
        ref_date_fig])
        )



#### Scatter geo data on map

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

##### heatmap

    import streamlit as st
    import pandas as pd
    import plotly.express as px
    import datetime
    import base64

    def heatmap(df):
        month_hours = {'January': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'February': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'March': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'April': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'May': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'June': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'July': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'August': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'September': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'October': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'November': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None},

        'December': {'12AM': None, '01AM': None, '02AM': None, '03AM': None, '04AM': None, '05AM': None,
                '06AM': None, '07AM': None, '08AM': None, '09AM': None, '10AM': None, '11AM': None,
                '12PM': None, '01PM': None, '02PM': None, '03PM': None, '04PM': None, '05PM': None,
                '06PM': None, '07PM': None, '08PM': None, '09PM': None, '10PM': None, '11PM': None}
        }

        for i in range(len(df)):
            month_hours[df.iloc[i][0]][df.iloc[i][1]] = df.loc[i]['Value']

        data_rows = list(month_hours.values())
        data = []

        for i in range(0,len(data_rows)):
            data.append(list(data_rows[i].values()))

        fig = px.imshow(data,
                        labels=dict(x="Hour", y="Month", color="Value"),
                        x=['12AM','01AM','02AM','03AM','04AM','05AM',
                        '06AM','07AM','08AM','09AM','10AM','11AM',
                        '12PM','01PM','02PM','03PM','04PM','05PM',
                        '06PM','07PM','08PM','09PM','10PM','11PM'],
                        y=['January','February','March','April','May','June',
                            'July','August','September','October','November','December']
                        )

        st.write(fig)

        return month_hours


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

    