---
layout:     post
title:      python data
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    - machine learning
---

## Faker
sample data can be created with faker module

### basics

    #pip install Faker
    from faker import Faker
    fake = Faker()
    #create fake name
    fake.name()
    #create fake job
    fake.job()
    #create fake address
    fake.address()
    #create fake birth date
    fake.date_of_birth(minimum_age=30)
    #create fake city
    fake.city()

#### specifying location
by adding location parameter in the class Faker, location-relevant information can be generated

    fake = Faker(['ja_JP','zh_CN','es_ES','en_US','fr_FR'])
    for _ in range(10):
        print(fake.city())

### Create Text

    fake.text()
    fake = Faker('ja_JP')
#### Create Text from Selected Words

    fake = Faker()
    my_information = [
    'dog','swimming', '21', 'slow', 'girl', 'coffee', 'flower','pink']
    fake.sentence(ext_word_list=my_information)

### Create profile

    fake.profile()
    #create a bunch of profile in dataframe
    import pandas as pd
    fake = Faker(['it_IT','ja_JP', 'zh_CN', 'de_DE','en_US'])
    profiles = [fake.profile() for i in range(100)]
    pd.DataFrame(profiles).head()

### Create random datatype

    fake.pylist(nb_elements=5, variable_nb_elements=True)
### Create decimal
    fake.pydecimal(left_digits=5, right_digits=6, positive=False, min_value=None, max_value=None)

## schema

    pip install schema
### validate data type

    from schema import Schema
    #validate all data or part of data 
    schema = Schema([{'name': str,
                    'city': str, 
                    'closeness (1-5)': int,
                    'extrovert': bool,
                    'favorite_temperature': float}])
    #show detail valid information
    schema.validate(data)
    #show only true/false
    schema.is_valid(data)
#### validate with function

    schema = Schema([{'name': str,
                 'city': str, 
                 'favorite_temperature': float,
                 #check whether value in range of 1-5
                  'closeness (1-5)': lambda n : 1 <= n <= 5,
                  str: object
                 }])
    schema.is_valid(data)

#### utilize logic operator

    schema = Schema([{'name': str,
                #check whether city contain one or two words, and is string
                'city': And(str, Or(lambda n: len(n.split())==2, lambda n: len(n.split()) ==1)),
                'favorite_temperature': float,
                #check whether value in range of 1-5 and is float
                'closeness (1-5)': And(lambda n : 1 <= n <= 5, float),
                str: object
                }])

#### Optional
make check optional if this data check not necessary for all datas

    schema = Schema([{'name': str,
            'favorite_temperature': float,
            Optional('detailed_info'): {'favorite_color': str, 'phone number': str}
            }])

#### Forbidden
make sure a certain kind of data is not in our data

    schema = Schema([{'name': str,
            'favorite_temperature': float,
            Optional('detailed_info'): {'favorite_color': str, 'phone number': str}
            }])

### convert data type

    Schema(Use(int)).validate('123')

## others
### sklearn.dataset

    from sklearn.datasets import make_blobs
    raw_data = make_blobs(n_samples = 200, n_features = 2, centers = 4, cluster_std = 1.8)