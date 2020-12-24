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

### apply
allows you to apply a function across an axis of a DataFrame or to a Series.    
xis allows you to define which axis the function is going to be applied to.      
If raw=False is passed then the row or column is passed to the apply function as a Series, if raw=True is passed then ndarray objects are passed to the function instead

        # pandas.DataFrame.apply
        DataFrame.apply(func, axis=0, raw=False, result_type=None, args=(), **kwds)
        # pandas.Series.apply
        Series.apply(func, convert_dtype=True, args=(), **kwds)

        #example
        import pandas as pd
        import numpy as np
        df = pd.DataFrame([[np.random.randint(1, 100), np.random.randint(1, 100)]] * 4, columns=['A', 'B'])
        print(df)
        print(df.apply(lambda x: [5, 10], axis=1))
        print(df.apply(lambda x: [5, 10, 15], axis=1, result_type='expand'))
        print(df.apply(lambda x: [5, 10], axis=1, result_type='broadcast'))
        print(df.apply(lambda x: [5, 10], axis=1, result_type='reduce'))
        #example1
        series = pd.Series(np.random.randint(0, 100, 5), name='result')
        df = pd.DataFrame(series)
        df['in_range'] = df['result'].apply(between_range, args=(25, 75))
        print(df)

### eval

        #create new data
        result2 = df.eval('''
                       years_to_now = 2020 - release_year
                       new_date_added = @pd.to_datetime(date_added.str.strip(), format='%B %d, %Y', errors='coerce')''')
        # use partial to fix expression
        from functools import partial
        func = partial(pd.to_datetime, format='%B %d, %Y', errors='coerce')
        netflix.eval('''
                years_to_now = 2020 - release_year
                new_date_added = @func(date_added.str.strip())''')

## plot
there are visualization features in pandas

### usage

        import pandas as pd
        df= pd.DataFrame(np.random.rand(8, 4), columns=['A','B','C','D'])
        #since the plot is based on matplotlib, we can change thema with seaborn
        import seaborn as sns
        sns.set_palette("pastel", 8)
        #sns.set_palette("Blues_r", 8)
        #sns.set_palette("magma", 8)
        df.plot.bar()
        df.plot.barh(stacked=True)
        df.plot.area(stacked=True,alpha = 0.9)
        df.plot.kde()

        df = pd.DataFrame({'a': np.random.randn(1000) + 1,
                   'b': np.random.randn(1000),
                   'c': np.random.randn(1000) - 1},
                  columns=['a', 'b', 'c'])
        df.plot.hist(stacked=True, bins=20)
        df.plot.hist(alpha=0.5)
        df.plot.box()
        df['value'].plot()
        df.plot.scatter()
        data.plot.hexbin(x='A',y='B')
        #subplot
        data.plot(subplots=True,layout=(3, 2), figsize=(15, 8))

## string methods

### StringDtype
object type is default to store strings, which has some drawbacks. with specification of string or StringDtype we can use StringDtype

        import pandas as pd
        pd.Series(['aaa','bbb','ccc']).dtype
        dtype('O')
        pd.Series(['aaa','bbb','ccc'], dtype='string').dtype
        StringDtype
        pd.Series(['aaa','bbb','ccc'], dtype=pd.StringDtype()).dtype
        StringDtype
### convert text to word series

        #explode function to use each separated word as a new item in the series
        #A would have the index 0 due to the nature of the explode function, so here is droped
        A = pd.Series(text).str.split().explode().reset_index(drop=True)

### convert upper-/lowercase 

        A.str.upper()
        A.str.lower()

### len

        #return length of each string in A
        A.str.len()

### string series to text

        A.str.cat(sep=" ")

### replace
it replace not only whole string, but also part of the string if any

        A.str.replace('the', 'not-a-word')

### regex

        #extract part of the string
        B = pd.Series(['a1','b4','c3','d4','e3'])
        B.str.extract(r'([a-z])([0-9])')
        #check whether string has same pattern
        C = pd.Series(['a1','4b','c3','d4','e3'])
        C.str.contains(r'[a-z][0-9]')

### count character in stirng

        B = pd.Series(['aa','ab','a','aaa','aaac'])
        B.str.count('a')
### filtering

        B = pd.Series(['aa','ba','ad'])
        B.str.startswith('a')
        B.str.endswith('d')

### string to categorial

        cities = ['New York', 'Rome', 'Madrid', 'Istanbul', 'Rome']
        pd.Series(cities).str.get_dummies()

## sql
### create dummy data

        df = pd.DataFrame({'name': ['Ann', 'Ann', 'Ann', 'Bob', 'Bob'], 
                   'destination': ['Japan', 'Korea', 'Switzerland', 
                                   'USA', 'Switzerland'], 
                   'dep_date': ['2019-02-02', '2019-01-01', 
                                '2020-01-11', '2019-05-05', 
                                '2020-01-11'], 
                   'duration': [7, 21, 14, 10, 14]})

### shift()

        SELECT name
                , destination
                , dep_date
                , duration
                , LEAD(dep_date) OVER(ORDER BY dep_date, name) AS lead1
                , LEAD(dep_date, 2) OVER(ORDER BY dep_date, name) AS lead2
                , LAG(dep_date) OVER(ORDER BY dep_date, name) AS lag1
                , LAG(dep_date, 3) OVER(ORDER BY dep_date, name) AS lag3
        FROM df
        #in python pandas it equals to
        df.sort_values(['dep_date', 'name'], inplace=True)
        df=df.assign(lead1 = df['dep_date'].shift(-1),
                lead2 = df['dep_date'].shift(-2),
                lag1 = df['dep_date'].shift(),
                lag3 = df['dep_date'].shift(3))

### Date/datetime

        SELECT name
                , destination
                , dep_date
                , duration
                , DATENAME(WEEKDAY, dep_date) AS day
                , DATENAME(MONTH, dep_date) AS month
                , DATEDIFF(DAY,  
                                LAG(dep_date) OVER(ORDER BY dep_date, name), 
                                dep_date) AS diff
                , DATEADD(DAY, day, dep_date) AS arr_date
        FROM df
        #equals to 
        df['dep_date'] = pd.to_datetime(df['dep_date'])
        df['duration'] = pd.to_timedelta(df['duration'], 'D')
        df.sort_values(['dep_date', 'name'], inplace=True)
        df.assign(day = df['dep_date'].dt.day_name(),
                month = df['dep_date'].dt.month_name(),
                diff = df['dep_date'] - df['dep_date'].shift(),
                arr_date = df['dep_date'] + df['duration'])
### Ranking

        SELECT name
                , destination
                , dep_date
                , duration
                , ROW_NUMBER() OVER(ORDER BY duration, name) AS row_number_d
                , RANK() OVER(ORDER BY duration) AS rank_d
                , DENSE_RANK() OVER(ORDER BY duration) AS dense_rank_d
        FROM df
        #equal to
        df.sort_values(['duration', 'name']).assign(
                row_number_d = df['duration'].rank(method='first').astype(int),
                rank_d = df['duration'].rank(method='min').astype(int),
                dense_rank_d = df['duration'].rank(method='dense').astype(int))

### Aggregate & Partition

        SELECT name
                , destination
                , dep_date 
                , duration
                , MAX(duration) OVER() AS max_dur
                , SUM(duration) OVER() AS sum_dur
                , AVG(duration) OVER(PARTITION BY name) AS avg_dur_name
                , SUM(duration) OVER(PARTITION BY name ORDER BY dep_date
                                        RANGE BETWEEN UNBOUNDED PRECEDING
                                        AND CURRENT ROW) AS cum_sum_dur_name
        FROM df
        #equal to
        df.sort_values(['name', 'dep_date'], inplace=True)
        df.assign(max_dur=df['duration'].max(),
                sum_dur=df['duration'].sum(),
                avg_dur_name=df.groupby('name')['duration']
                                .transform('mean'),
                cum_sum_dur_name=df.sort_values('dep_date')
                                .groupby('name')['duration']
                                .transform('cumsum'))

## indexing
### loc
dataframe.loc[specified rows in list: specified columns in list]
#or
dataframe.loc[start label row: stop label row, start lable column: start lable column]
#or
dataframe.loc[dataframe.<attribute> == <selected attribute tpye>, :]
### iloc
integer-location based indexing based on the position of the rows and columns.  
the end index will not be included in the selected dataframe    
dataframe.iloc[start index row:end index row, start index column:end index column]

## iterating

### DataFrame.iterrows()

        for index, row in df.iterrows():
                print(f'Index: {index}, row: {row.values}')
                #only print column_a
                print(f'Index: {index}, column_a: {row.get("column_a", 0)}')

### DataFrame.itertuples()
returns an iterator containing name tuples representing the column names and values

        # DataFrame.itertuples(index=True, name='Pandas')
        for row in df.itertuples():
                print(row)
                print(row.column_name)

## Garbage Collector
by processing big data using pandas dataframe, it is important to delete the unused reference and use gc.collect method, so that the memory will be returned to system

        import pandas as pd
        import sys  #system specific parameters and names
        import gc   #garbage collector interface

        def obj_size_fmt(num):
                if num<10**3:
                        return "{:.2f}{}".format(num,"B")
                elif ((num>=10**3)&(num<10**6)):
                        return "{:.2f}{}".format(num/(1.024*10**3),"KB")
                elif ((num>=10**6)&(num<10**9)):
                        return "{:.2f}{}".format(num/(1.024*10**6),"MB")
                else:
                        return "{:.2f}{}".format(num/(1.024*10**9),"GB")


        def memory_usage():
                memory_usage_by_variable=pd.DataFrame({k:sys.getsizeof(v)\
                for (k,v) in globals().items()},index=['Size'])
                memory_usage_by_variable=memory_usage_by_variable.T
                memory_usage_by_variable=memory_usage_by_variable\
                .sort_values(by='Size',ascending=False).head(10)
                memory_usage_by_variable['Size']=memory_usage_by_variable['Size']
                \.apply(lambda x: obj_size_fmt(x))
                return memory_usage_by_variable

        #deleting references
        del df
        del df2

        #triggering collection
        gc.collect()

        #finally check memory usage
        memory_usage()

## feature engineering
feature is to extract new feature from existing dataset

### replace() for Label encoding
dynamically replaces current values with the given values. The new values can be passed as a list, dictionary, series, str, float, and int

        data['Outlet_Location_Type_Encoded']  = data['Outlet_Location_Type'] \
                                            .replace({'Tier 1': 1, 'Tier 2': 2, 'Tier 3': 3})

### get_dummies() for One Hot Encoding
convert a categorical variable to one hot variable.

        #the parameter drop_first, which drops the first binary column to avoid perfect multicollinearity
        Outlet_Type_Dumm = pd.get_dummies(data=data['Outlet_Type'], columns=['Outlet_Type'], drop_first=True)
        pd.concat([data['Outlet_Type'], Outlet_Type_Dumm], axis=1).head()

### cut() and qcut() for Binning
grouping together values of continuous variables into n number of bins. qcut divide the bins into the same frequency groups; cut divide the bins with explicitly defined bin edges

        groups = ['Low', 'Med', 'High', 'Exp']
        data['Item_MRP_Bin_qcut'] = pd.qcut(data['Item_MRP'], q=4, labels=groups)
        data[['Item_MRP', 'Item_MRP_Bin_qcut']].head()

        bins = [0, 70, 140, 210, 280]
        groups = ['Low', 'Med', 'High', 'Exp']
        data['Item_MRP_Bin_cut'] = pd.cut(data['Item_MRP'], bins=bins, labels=groups)
        data[['Item_MRP', 'Item_MRP_Bin_cut']].head()

### apply() for Text Extraction
apply a function to every variable of dataframe

        data['Item_Code'] = data['Item_Identifier'].apply(lambda x: x[0:2])
        data[['Item_Identifier', 'Item_Code']].head()

### value_counts() and apply() for Frequency Encoding
Frequency Encoding is an encoding technique that encodes categorical feature values to their respected frequencies.

        Item_Type_freq = data['Item_Type'].value_counts(normalize=True)
        # Mapping the encoded values with original data 
        data['Item_Type_freq'] = data['Item_Type'].apply(lambda x : Item_Type_freq[x])
        print('The sum of Item_Type_freq variable:', sum(Item_Type_freq))
        data[['Item_Type', 'Item_Type_freq']].head(6)

### groupby() and transform() for Aggregation Features
Groupby is a function that can split the data into various forms to get information that was not available on the surface.

        data['Item_Outlet_Sales_Mean'] = data.groupby(['Item_Identifier', 'Item_Type'])['Item_Outlet_Sales']\
                                        .transform(lambda x: x.mean())
        data[['Item_Identifier','Item_Type','Item_Outlet_Sales','Item_Outlet_Sales_Mean']].tail()

### Series.dt() for date and time based features

        data['pickup_year'] = data['pickup_datetime'].dt.year
        data['pickup_dayofyear']  = data['pickup_datetime'].dt.day
        data['pickup_monthofyear'] = data['pickup_datetime'].dt.month
        data['pickup_hourofday'] = data['pickup_datetime'].dt.hour
        data['pickup_dayofweek'] = data['pickup_datetime'].dt.dayofweek
        data['pickup_weekofyear'] = data['pickup_datetime'].dt.weekofyear

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

### read excel

        # callable function to read useful data
        # Define a more complex function:
        def column_check(x):
        if 'unnamed' in x.lower():
                return False
        if 'priority' in x.lower():
                return False
        if 'order' in x.lower():
                return True
        return True

        df = pd.read_excel(src_file, header=1, usecols=column_check)
        #or directly with column name list
        df = pd.read_excel(
        src_file,
        header=1,
        usecols=['item_type', 'order id', 'order date', 'state', 'priority'])

### itertuples instead of the iterrows

        [sum_square(row[0], row[1]) for _, row in df.iterrows()]
        #can be optimized into 
        [sum_square(a, b) for a, b in df[[0, 1]].itertuples(index=False)]

### vectorization

        [sum_square(row[0], row[1]) for _, row in df.iterrows()]
        #can be optimized into
        np.vectorize(sum_square)(df[0], df[1])
        #or
        np.power(df[0] + df[1], 2)

### parallelisation
If your function is I/O bound, meaning that it is spending a lot of time waiting for data (e.g. making api requests over the internet), then multithreading (or thread pool) will be the better and faster option