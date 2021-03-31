---
layout:     post
title:      Geocoding
subtitle:   
date:       2020-12-27
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## Simple map geo data on map
### get geo data
#### GeoPy

    from geopy.geocoders import Nominatim
    #openstreet map
    geolocator = Nominatim(user_agent="example app")
    #google map
    geolocator = GoogleV3(api_key=AUTH_KEY)
    geolocator.geocode("Tuscany, Italy").raw
    geolocator.geocode("Tuscany, Italy").point
    geolocator.geocode("1 Apple Park Way, Cupertino, CA")
    geolocator.reverse('37.3337572, -122.0113815')

### map Geopoint to map
#### folium
folium is a python library to visualize data on an interactive leaflet map

    #pip install folium
    # import the library and its Marker clusterization service
    import folium
    from folium.plugins import MarkerCluster
    # Create a map object and center it to the avarage coordinates to m
    m = folium.Map(location=df[["lat", "lon"]].mean().to_list(), zoom_start=2)
    # if the points are too close to each other, cluster them, create a cluster overlay with MarkerCluster, add to m
    marker_cluster = MarkerCluster().add_to(m)
    # draw the markers and assign popup and hover texts
    # add the markers the the cluster layers so that they are automatically clustered
    for i,r in df.iterrows():
        location = (r["lat"], r["lon"])
        folium.Marker(location=location,
                        popup = r['Name'],
                        tooltip=r['Name'])\
        .add_to(marker_cluster)
    # display the map
    m
    #save to html
    m.save("folium_map.html")

##### Stamen Toner Maps
high contrast Black & White maps

    #add attribute tiles='Stamen Toner' to folium.map() to create stamen toner map
    india_map = folium.Map(location=[20.5937, 78.9629 ], zoom_start=4,              tiles='Stamen Toner')

##### Stamen Terrain Maps
show hill shading and natural vegetation colors

    #add attribute tiles='Stamen Terrain' to folium.map() to create stamen terrain map
    india_map = folium.Map(location=[20.5937, 78.9629 ], zoom_start=4, tiles='Stamen Terrain')

#### plotly

    # import the plotly express
    import plotly.express as px
    # set up the chart from the df dataFrame
    fig = px.scatter_geo(df, 
                        # longitude is taken from the df["lon"] columns and latitude from df["lat"]
                        lon="lon", 
                        lat="lat", 
                        # choose the map chart's projection
                        projection="natural earth",
                        # columns which is in bold in the pop up
                        hover_name = "Name",
                        # format of the popup not to display these columns' data
                        hover_data = {"Name":False,
                                    "lon": False,
                                    "lat": False
                                        }
                        )
    #set size and color
    fig.update_traces(marker=dict(size=25, color="red"))
    #set view location and country
    fig.update_geos(fitbounds="locations", showcountries = True)
    fig.update_layout(title = "Your customers")
    fig.show()
    fig.write_html("plotly_map.html", include_plotlyjs=True)

## view bus traffic on map
### get traffic schedule data

import requests, json, schedule, urllib.request, time
import numpy as np
import pandas as pd

from requests.auth import HTTPBasicAuth
from google.transit import gtfs_realtime_pb2
from google.protobuf.json_format import MessageToJson
from vincenty import vincenty
from geojson import LineString,Feature,FeatureCollection,dump

#function to preprocess data
def dfColumns(varName, columnName, df):
    returned = []
    for i in range(len(df['vehicle'])):
        if varName == 'exist':
            try:
                returned.append(df['vehicle'][i][columnName])
            except:
                returned.append('NA')
        elif columnName == 'tripId':
            try:
                returned.append(df['vehicle'][i][varName][columnName])
            except:
                name = df['vehicle'][i]['vehicle']['id'] + '-idle'
                returned.append(name)
        else:
            try:
                returned.append(df['vehicle'][i][varName][columnName])
            except:
                returned.append('NA')
    return(returned)

#get RTD (Regional Transportation District) data
def rtd():
    # Call this every minute
    request = requests.get('http://googlefeeder.rtd-denver.com/google_sync/VehiclePosition.pb', auth=HTTPBasicAuth('BASIC_AUTH_username', 'BASIC_AUTH_password'))
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.ParseFromString(request.content)

    # Message to JSON
    pb_as_json= MessageToJson(feed)

    # String to JSON conversion
    data = json.loads(pb_as_json)
    
    try:
        # df Creation
        df = pd.DataFrame(data['entity'])
        df['tripId'] = dfColumns('trip','tripId',df)
        df['routeId'] = dfColumns('trip','routeId',df)
        df['directionId'] = dfColumns('trip','directionId',df)
        df['currentStatus'] = dfColumns('exist','currentStatus',df)
        df['stopId'] = dfColumns('exist','stopId',df)
        df['latitude'] = [df['vehicle'][x]['position']['latitude'] for x in range(len(df['vehicle']))]
        df['longitude'] = [df['vehicle'][x]['position']['longitude'] for x in range(len(df['vehicle']))]
        df['bearing'] = [df['vehicle'][x]['position']['bearing'] for x in range(len(df['vehicle']))]
        df['timestamp'] = [df['vehicle'][x]['timestamp'] for x in range(len(df['vehicle']))]
        df['vid'] = [df['vehicle'][x]['vehicle']['id'] for x in range(len(df['vehicle']))]

        print('df Completed.')
        for i in range(len(df)):
            ts = time.time()
            longitude=df.iloc[i]["longitude"]
            latitude=df.iloc[i]["latitude"]
            timestamp=df.iloc[i]["timestamp"]
            bearing=df.iloc[i]["bearing"]
            vid=df.iloc[i]["vid"]
            tripid=df.iloc[i]["tripId"]
            routeid=df.iloc[i]["routeId"]
            dirid=df.iloc[i]["directionId"]
            curstatus=[df.iloc[i]["currentStatus"]]
            stopid=[df.iloc[i]["stopId"]]
            location_sub_list=[float(longitude),float(latitude),float(bearing),int(timestamp)]
            if longitude!=0:
                if tripid in busdata.keys():
                    busdata[tripid]["location"].append(location_sub_list)
                    busdata[tripid]["current_status"].extend(curstatus)
                    busdata[tripid]["stopId"].extend(stopid)
                else:
                    busdata[tripid]={"location":[location_sub_list], "vid":vid,"stopId":stopid, "current_status":curstatus, "direction_id":dirid}
            else:
                pass
    except Exception as e:
        print(e)
        pass

#fetch data every min for one day
busdata = {}
schedule.every(1).minutes.do(rtd)
while True:
    schedule.run_pending()

features = []
for x in busdata.keys():
    route=LineString(busdata[x]["location"])
    features.append(Feature(geometry=route, properties={"vid":busdata[x]["vid"]}))
feature_collection = FeatureCollection(features)

with open('smalltest.geojson', 'w') as f:
   dump(feature_collection, f)

### process data 

# Speed calculation
df = pd.read_json("smalltest.geojson")

for j in range(len(df['features'])):
    s = []
    for i in range(len(df['features'][j]['geometry']['coordinates'])-1):
        loc1 = df['features'][j]['geometry']['coordinates'][i][1],df['features'][j]['geometry']['coordinates'][i][0]
        loc2 = df['features'][j]['geometry']['coordinates'][i+1][1],df['features'][j]['geometry']['coordinates'][i+1][0]
        time1 = df['features'][j]['geometry']['coordinates'][i][3]
        time2 = df['features'][j]['geometry']['coordinates'][i+1][3]
        distance = vincenty(loc1,loc2, miles=True)
        traveltime = time2-time1
        #print(distance, (traveltime/3600), time2, time1)
        if int(traveltime) > 0:
            speed = distance / (traveltime/3600)
            if speed > 50:
                speed =  50
            else:
                speed = speed
            s.append(speed)
            #print(speed)
        else:
            s.append(0)
    if len(s)>0:
        mean = np.mean(s)
    else:
        mean = 0
    df['features'][j]['properties']['speed'] = mean

#update geo json
features = []
for i in range(len(df['features'])):
    if len(df['features'][i]['geometry']['coordinates'])>0:
        route=LineString(df['features'][i]['geometry']['coordinates'])
        vid = df['features'][i]['properties']['vid']
        speed = df['features'][i]['properties']['speed']
        features.append(Feature(geometry=route, properties={"vid":vid, "speed":speed}))
feature_collection = FeatureCollection(features)

with open('smalltest-w-speed.geojson', 'w') as f:
   dump(feature_collection, f)

### visualize data 
the geo data can be visualized with https://kepler.gl/demo or https://studio.unfolded.ai/home
