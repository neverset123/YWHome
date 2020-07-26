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

## destructuring

    #a=[1,2], b=[3,4]
    [a, b] = [[1,2],[3,4]]
    # a=('x',1),  b=('y', 2)
    myDict={'x':1, 'y':2}
    a,b=myDict.items()
    #enumerate
    myList = ["a", "b", "c"]
    for i, element in enumerate(myList):
        print(i, element)
    #asterisk
    def sum(a, b, c):
        return a + b + c
    x = (1, 2, 3)
    print(result(*x))
    #*_ omit an unknown number of values
    #first is 'H', last is 'o'
    first, *_, last = "Hello"

## Get Method for Dictionaries
with get method instead of direct indexing it is possible to get an replaced value rather than error if key does not existss

    dictionary.get('three', False)

## Tree Datatypes

    class Tree(dict):
        def __missing__(self, key):
            value = self[key] = type(self)()
            return value

    #example 
    tree = Tree()
    tree['carnivora']['canis']['c.lupus'] = 'c.l.familiaris'
    tree['carnivora']['felis'] = 'f.catus'
    print(tree)

## list indexing
list indexing can be used in following way:

    list[start:end:step]

a named slices is more advanced for this kind of indexing

    x = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
    new_slice = slice(3, 8, 2)
    x[new_slice]

## f-string

    #old method
    print("Happy %s, %s. Welcome to Python!" % (day, name))
    #str.format() method
    print("Happy {}, {}. Welcome to Python!".format(day, name))
    #f-string, recommended to use
    name = "Monty"
    day = "Tuesday"
    print(f"Happy {day}, {name}. Welcome to Python!")

## list comprehension
new_list = [expression for item in iterable (if conditional)]

## create N-length lists

    #[None, None, None, None]
    four_nones = [None] * 4
    #[[], [], [], []]
    four_lists = [[] for __ in range(4)]

## delete element of lists
In short, don’t use for loops when you’re deleting items from a list, rather use list comprehension

    foos = [value for value in a if value != 'bar']

## Unpack arguments with *, **, and _
* A variable beginning with * can hold as any number of elements
    #1st example
    long_list = [x for x in range(100)]
    a, b, *c, d, e, f = long_list
    #2nd example
    def printfunction(*args):
        print(args)

* ** operator can unpack dictionaries to a function

    def myfriendsfunction(name, age, profession):
...     print("Name: ", name)
...     print("Age: ", age)
...     print("Profession: ", profession)
    friendanne = {"name": "Anne", "age": 26, "profession": "Senior Developer"}
    myfriendsfunction(**friendanne)

## dir() return all attributes and methods of an object

## sys.getsizeof() get memory usage of a variable

## split lines with () rather thatn \

    big_string = (
    "This is the beginning of a really long story. "
    "It's full of magicians, dragons and fabulous creatures. "
    "Needless to say, it's quite scary, too."
    )

## use type hints

    def sayhello(day:str, name:str) -> str:
        return f"Happy {day}, {name}. Welcome to Python!"