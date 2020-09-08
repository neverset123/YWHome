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

### preprocess data to change type
after read data, the data type of all data is string. Before processing (such as logical comparison) it makes sense to assign type to them

    df = df.astype({"Open":'float',
                "High":'float',
                "Low":'float',
                "Close*":'float',
                "Adj Close**":'float',
                "Volume":'float'})

### Logical Comparisons wrapper
eq (equivalent to ==) — equals to
ne (equivalent to !=) — not equals to
le (equivalent to <=) — less than or equals to
lt (equivalent to <) — less than
ge (equivalent to >=) — greater than or equals to
gt (equivalent to >) — greater than

    df['Bool Price Increase'] = df['Close*'].gt(df['Open'])
    df['Bool Over Time Increase'] = df['Close*'].gt(df['Close*'].shift(-1))

### persisting data without csv
csv does nto persist data type of pandas
alternative:
* Pickle and to_pickle()
    #Pandas's to_pickle method
    df.to_pickle(path)  
* Parquet and to_parquet()
    #Pandas's to_parquet method
    df.to_parquet(path, engine, compression, index, partition_cols)
* Excel and to_excel()
    #exporting a dataframe to excel
    df.to_excel(excel_writer, sheet_name, many_other_parameters)
* HDF5 and to_hdf()
If the data are stored as table (PyTable) you can directly query the hdf store using store.select(key,where="A>0 or B<5")
    #exporting a dataframe to hdf
    df.to_hdf(path_or_buf, key, mode, complevel, complib, append ...)
* SQL and to_sql()
    #Set up sqlalchemy engine
    engine = create_engine(
        'mssql+pyodbc://user:pass@localhost/DB?driver=ODBC+Driver+13+for+SQL+server',
        isolation_level="REPEATABLE READ"
    )
    #connect to the DB
    connection = engine.connect()
    #exporting dataframe to SQL
    df.to_sql(name="test", con=connection)

### Pandas Profile
pandas profile provides EDA information about datas to be analysed

    import pandas_profiling
    import pandas as pd
    import numpy as np
    # create data 
    df = pd.DataFrame(np.random.randint(0,200,size=(15, 6)), columns=list('ABCDEF'))
    # run your report!
    df.profile_report()