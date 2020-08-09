---
layout:     post
title:      python data cleanings
subtitle:   
date:       2020-07-12
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    - pandas
---


## missing value

    # a list with all missing value formats
    missing_value_formats = ["n.a.","?","NA","n/a", "na", "--"]
    df = pd.read_csv("employees.csv", na_values = missing_value_formats)   

## invalid data type

    def make_int(i):
        try:
            return int(i)
        except:
            return pd.np.nan

    # apply make_int function to the entire series using map
    df['Salary'] = df['Salary'].map(make_int)

## marking&removing missing values

    # check if there are missing values in dataframe
    print(df.isnull().values.any())
    # statistically list missing value
    print(df.isnull().sum())
    # notnull will return False for all NaN values
    null_filter = df['Gender'].notnull()
    # drop all rows with NaN values
    df.dropna(axis=0,inplace=True)
    # drop all rows with atleast one NaN
    new_df = df.dropna(axis = 0, how ='any')  
    # drop all rows with all NaN
    new_df = df.dropna(axis = 0, how ='all')

## filling missing values

    # replace na with constants
    df['Salary'].fillna(0, inplace=True)
    # or with replace function 
    df['Salary'].replace(to_replace = np.nan, value = 0,inplace=True)
    # replace na with value in previous row
    df['Salary'].fillna(method='pad', inplace=True)
    # replace na with value in next row
    df['Salary'].fillna(method='bfill', inplace=True)
    # interpolation
    df['Salary'].interpolate(method='linear', direction = 'forward', inplace=True)

## pandas tips
### filter with query()

    #filter can be done like this
    df.loc[(df['tip']>6) & (df['total_bill']>=30)]
    # filter is more elegant with query
    df.query("tip>6 & total_bill>=30")

    # reference global variable name with @
    median_tip = df['tip'].median()
    display(df.query("tip>@median_tip").head())

### sorting multiple columns

    df.sort_values(by=[‘total_bill’, ‘tip’], ascending=[True, False]).head()

### Use nsmallest() or nlargest()
check out data extract for records that have the smallest or largest values in a particular column

    df.nsmallest(5, 'total_bill')

### Customise describe()
summary stats for selected columns

    display(df.describe(include=['category'])) # categorical types
    display(df.describe(include=['number'])) # numerical types