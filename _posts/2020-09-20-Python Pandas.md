---
layout:     post
title:      python pandas
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    - pandas
---

## manipulate dataframe
### add row and colume name

        import numpy as np
        import pandas as pdvalues = np.random.randint(10, size=(3,7))
        df = pd.DataFrame(values, columns=list('ABCDEFG'))
        df.insert(0, 'category', ['cat1','cat2','cat3'])
### melt
convert dataframe with high number of columns to narrow ones
The column specified with the id_vars parameter remains the same and the other columns are represented under the variable and value columns

        df_melted = pd.melt(df, id_vars='category')

### stack

        df_stacked = df_measurements.stack().to_frame()
        #unstack
        df_stacked.unstack()

### adding or drop volumn

        #created a new column with a list
        df['city'] = ['Rome','Madrid','Houston']
        #inplace parameter is set to True in order to save the changes
        df.drop(['E','F','G'], axis=1, inplace=True)

### insert
insert column at defined location
        #insert column at first column
        df.insert(0, 'first_column', [4,2,5])

### add or drop row

        new_row = {'A':4, 'B':2, 'C':5, 'D':4, 'city':'Berlin'}
        df = df.append(new_row, ignore_index=True)
        df.drop([3], axis=0, inplace=True)

### pivot function

        #return dataframe contains the mean values for each city-cat pair
        df.pivot_table(index='cat', columns='city', aggfunc='mean')

### join

        #merge dataframe according to defined id
        pd.merge(df1, df2, on='id')
        #if the column names on two dataframes are different
        pd.merge(df1, df2, left_on='id', right_on='number')
        #select join method: innner join，left join，right join or outer join
        pd.merge(df1, df2, left_on='id', right_on='number', how='left')
### concat

        #concatenate in column
        pd.concat([df1, df2], axis=1)


## useful tips
### read from clipboard

        pd.read_clipboard()

### generate test data

        pd.util.testing.N = 10
        pd.util.testing.K = 5
        pd.util.testing.makeDataFrame()

### save data in compressed file

        #compress data to file
        df.to_csv('sample.csv.gz', compression='gzip')
        #read compressed file to pd
        f = pd.read_csv('sample.csv.gz', compression='gzip', index_col=0)