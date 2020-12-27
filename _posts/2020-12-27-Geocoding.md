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

## get geo data
### GeoPy

    from geopy.geocoders import Nominatim
    #openstreet map
    geolocator = Nominatim(user_agent="example app")
    #google map
    geolocator = GoogleV3(api_key=AUTH_KEY)
    geolocator.geocode("Tuscany, Italy").raw
    geolocator.geocode("Tuscany, Italy").point
    geolocator.geocode("1 Apple Park Way, Cupertino, CA")
    geolocator.reverse('37.3337572, -122.0113815')

## map Geopoint to map
### folium

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

### plotly

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