---
layout:     post
title:      geo visualization
subtitle:   
date:       2022-10-15
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - visualization
---


## cartopy
cartopy is based on matplotlib, can visualize geo information combining with proj, numpy and shapely.

```
import cartopy.crs as ccrs
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
import matplotlib.pyplot as plt


def main():
    fig = plt.figure(figsize=(8, 10))

    # Label axes of a Plate Carree projection with a central longitude of 180:
    ax1 = fig.add_subplot(2, 1, 1,
                          projection=ccrs.PlateCarree(central_longitude=180))
    ax1.set_global()
    ax1.coastlines()
    ax1.set_xticks([0, 60, 120, 180, 240, 300, 360], crs=ccrs.PlateCarree())
    ax1.set_yticks([-90, -60, -30, 0, 30, 60, 90], crs=ccrs.PlateCarree())
    lon_formatter = LongitudeFormatter(zero_direction_label=True)
    lat_formatter = LatitudeFormatter()
    ax1.xaxis.set_major_formatter(lon_formatter)
    ax1.yaxis.set_major_formatter(lat_formatter)

    plt.show()


if __name__ == '__main__':
    main()
```
```
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt


def main():
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.PlateCarree())
    ax.set_extent([-20, 60, -40, 45], crs=ccrs.PlateCarree())

    ax.add_feature(cfeature.LAND)
    ax.add_feature(cfeature.OCEAN)
    ax.add_feature(cfeature.COASTLINE)
    ax.add_feature(cfeature.BORDERS, linestyle=':')
    ax.add_feature(cfeature.LAKES, alpha=0.5)
    ax.add_feature(cfeature.RIVERS)

    plt.show()


if __name__ == '__main__':
    main()
```

## geopandas
geopandas is mainly used to process geo data, it can also visualize geo data with help of matplotlib.
```
import geopandas as gpd
from matplotlib_scalebar.scalebar import ScaleBar

nybb = gpd.read_file(gpd.datasets.get_path('nybb'))
nybb = nybb.to_crs(32619)  # Convert the dataset to a coordinate
# system which uses meters

ax = nybb.plot()
ax.add_artist(ScaleBar(1))
```
```
import geopandas
import contextily as cx

df = geopandas.read_file(geopandas.datasets.get_path('nybb'))
ax = df.plot(figsize=(10, 10), alpha=0.5, edgecolor='k')

df.crs
df_wm = df.to_crs(epsg=3857)
ax = df_wm.plot(figsize=(10, 10), alpha=0.5, edgecolor='k')
cx.add_basemap(ax)
```

## folium

