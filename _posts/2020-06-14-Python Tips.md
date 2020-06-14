---
layout:     post
title:      python tips
subtitle:   
date:       2020-06-14
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## lambda function

    add = lambda a,b,c : a + b + c
    print( add(5,4,6) )

## map function

    def interest(amount):
        rate = 5
        year = 3    
        return amount * rate * year / 100amount = [10000, 12000, 15000]
    interest_list = list( map(interest,amount) )
    print( interest_list )

## filter function

    def eligibility(age):
        if(age>=24):
            return True
    list_of_age = [10, 24, 27, 33, 30, 18, 17, 21, 26, 25]
    age = filter(eligibility, list_of_age)
    print(list(age))
    #combine filter with lambda
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    even = list(filter(lambda x: x%2==0, numbers))
    print(even)

## reduce function

    from functools import reduce
    def add(a,b):
        return a+b
    list = [1, 2, 3, 4, 5]
    sum = reduce(add, list)
    print(list(sum))