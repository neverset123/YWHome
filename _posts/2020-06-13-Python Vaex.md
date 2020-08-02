---
layout:     post
title:      python vaex
subtitle:   
date:       2020-06-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - HDF5
    - big data
---

vaex uses lazy processing, means that read fields from file when needed
most advantages when dealing with HDF5 or Apache Arrow format

## conversion
if the original file is not in hdf we can convert it into hdf for calculation efficiency

    dv = vaex.from_csv(file_path, convert=True, chunk_size=5_000_000)
    #to open hdf5 directly
    dv = vaex.open('big_file.csv.hdf5')

## calculation

* sum   
suma = dv.col1.sum()
* plot  
dv.plot1d(dv.col2, figsize=(110.10)) 
* adding coloumn (virtual)
dv['col1_plus_col2'] = dv.col1 + dv.col2
* filter    
dvv = dv[dv.col1 > 90]
* aggregations
dv['col1_50'] = dv.col1 >= 50   
* join
v_join = dv.join(dv_group, on='new_coloumn')
