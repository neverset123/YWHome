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

## Assignment Expresions
allow return value in assignment 

    `
    any((ret := n) % 7 == 0 for n in nums)
    `

## lambda function

    add = lambda a,b,c : a + b + c
    print( add(5,4,6) )

## map function
map(function you want to apply, sequence of elements we want to apply it to)

    def interest(amount):
        rate = 5
        year = 3    
        return amount * rate * year / 100amount = [10000, 12000, 15000]
    interest_list = list( map(interest,amount) )
    print( interest_list )

## filter function
filter(function that checks for a condition, sequence of elements we want to apply it to)

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

## pipe
### filter with where

```
from pipe import where
arr = [1,2,3,4,5]
list(arr | where(lambda x. x%2==0))
```

### apply func to iterable
```
from pipe import select
arr = [1,2,3,4]
list(arr | select(lambda x: x*2))
#or combine where and select
list(arr
        | where(lambda x: x%2==0)
        | select(lambda x: x*2))
```
### unfold iterable
```
from pipe import traverse, select
fruits = [
    {"name":"apple", "price":[2,5]},
    {"name":orange", "price":4},
    {"name":"grape", "price":5}
]
lsit(fruites
        | select(lambda fruit:fruit["price"])
        | traverse)
```

## reduce function
reduce(function, iterable[, initializer])

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

## Ternary Expression
 define variables with particular values based on the conditions

    reward = "1000 dollars" if score > 90 else "500 dollars"

## Evaluate Multiple Conditions

    # Do these instead
    if all([a < 10, b > 5, c == 4]):
        # do something
    if any([a < 10, b > 5, c == 4]):
        # do something

## Use Counter for unique Element Counting

    from collections import Counter
    word_counter = Counter(x.lower() for x in words)
    #find the most frequently occurring element
    print("Most Frequent:", word_counter.most_common(1))

## sorting

    #sort list
    sorted(numbers, reverse=True))
    sorted(words, reverse=True)
    #sort list of tuples
    grades = [('John', 95), ('Aaron', 99), ('Zack', 97), ('Don', 92), ('Jennifer', 100), ('Abby', 94), ('Zoe', 99), ('Dee', 93)]
    # Sort by the grades, descending
    sorted(grades, key=lambda x: x[1], reverse=True)
    # Sort by the name's initial letter, ascending
    sorted(grades, key=lambda x: x[0][0])
    # sort with two keys
    sorted(grades, key=lambda x: (x[0][0], -x[1]))

## defaultdict
defaultdict can avoid key not exist error when putting list or tuple in dict

    from collections import defaultdict
    final_defaultdict = defaultdict(list)
    for letter in letters:
        final_defaultdict[letter].append(letter)

## any/all

    # finds an element that evalutes to True it can return True immediately
    found = any(thing == other_thing for thing in things)
    # return True only when all the elements evaluate to True
    found = all(thing == other_thing for thing in things)

## replace list() with []/ replace dict() with {}
time performance is better

## Replace if statement with if expression

    x = 1 if condition else 2

## Use items() to directly unpack dictionary values

    hats_by_colour = {'blue': ['panama', 'baseball_cap']}
    for hat_colour, hats in hats_by_colour.items():
        if hat_colour in self.favourite_colours:
            think_about_wearing(hats)
## Simplify sequence comparison
check whether a list or sequence has elements before we try and do something with it

    if len(list_of_hats) > 0:
    #can be shortened as 
    if list_of_hats:

## Replace multiple comparisons of same variable with in operator

    def process_payment(payment):
        if payment.currency == 'USD' or payment.currency == 'EUR':
            process_standard_payment(payment)
    #can be shortened into
    def process_payment(payment):
        if payment.currency in ['USD', 'EUR']:
            process_standard_payment(payment)

## Replace manual loop counter with call to enumerate

    i = 0
    for currency in currencies:
        print(i, currency)
        i += 1
    # can be shortened as
    for i, currency in enumerate(currencies):
        print(i, currency)


## data class
this feature is for python 3.7+

    from dataclasses import dataclass

    @dataclass
    class DataClassCard:
        rank: str
        suit: str
    
    queen_of_hearts = DataClassCard('Q', 'Hearts')
    queen_of_hearts.rank

## parallel computing
### processpoolexecutor
using concurrent.futures to process tasks with more processors

    with concurrent.futures.ProcessPoolExecutor() as executor:
        executor.map(func, args_for_func)

### Pool

    from multiprocessing.dummy import Pool as ThreadPool
    # Make the Pool of workers
    pool = ThreadPool(4)
    # Open the urls in their own threads
    # and return the results
    results = pool.map(urllib2.urlopen, urls)
    #close the pool and wait for the work to finish
    pool.close()
    pool.join()

### concurrent.futures.ProcessPoolExecutor()

### ppserver

### celery



## Interning
Interning is re-using the objects on-demand instead of creating the new objects.
is — this is used to compare the memory location of two python objects.
id — this returns memory location in base-10.

## joblib
### caching results

    from joblib import Memory

    #Define a location to store cache
    location = '~/Desktop/temp/cache_dir'
    memory = Memory(location, verbose=0)
    result = []

    #Function to compute square of a range of a number:
    def get_square_range_cached(start_no, end_no):
        for i in np.arange(start_no, end_no):
            time.sleep(1)
            result.append(square_number(i))
        return result

    get_square_range_cached = memory.cache(get_square_range_cached)

    start = time.time()
    final_result = get_square_range_cached(1, 21)
    end = time.time()

    #Clean-up the cache folder
    memory.clear(warn=False)

### parallelization

    from joblib import Parallel, delayed
    from joblib import Memory

    location = 'C:/Users/pg021/Desktop/temp/cache_dir'
    memory = Memory(location, verbose=0)
    costly_compute_cached = memory.cache(costly_compute)

    def data_processing_mean_using_cache(data, column):
        """Compute the mean of a column."""
        return costly_compute_cached(data, column).mean()

    start = time.time()
    results = Parallel(n_jobs=2)(
        delayed(data_processing_mean_using_cache)(data, col)
        for col in range(data.shape[1]))
    stop = time.time()

    print('Elapsed time for the entire processing: {:.2f} s'
        .format(stop - start))

### dump results

    from joblib import dump, load
    start = time.time()
    joblib_file = 'train_features.joblib'

    with open(path + joblib_file, 'wb') as f:
        dump(data, f)

    # Calculating the total time
    simple_joblib_duration = time.time() - start
    print("Dump duration: %0.3fs" % simple_joblib_duration)

    start = time.time()
    with open(path + joblib_file, 'wb') as f:
        load(data, f)

    # Calculating the total time
    simple_joblib_duration = time.time() - start
    print("Dump duration: %0.3fs" % simple_joblib_duration)

#### dump with compression

    start = time.time()
    joblib_file = '/train_features.joblib'

    # Dumping the file in the zlib compression format
    with open(path + joblib_file, 'wb') as f:
        dump(data, f, compress='zlib')

    simple_joblib_duration = time.time() - start

    # Total time taken to dump
    print("Zlib dump duration: %0.3fs" % simple_joblib_duration)

## plydata

    #example data
    import pandas as pd
    from plydata import define, query, if_else, ply
     
     
    df = pd.DataFrame({
        'x': [0, 1, 2, 3],
        'y': ['zero', 'one', 'two', 'three']})

### define
define(data, *args,**kwargs)

    #df won't be changed(no insert)
    define(df, z='x')
    #it equals to 
    df >> define(z='x')
    #for multi operations
    (df 
     >> define(m='2*x') 
     >> define(n='m*m') 
     >> define(q='m+n')
    )

### if_else
if_else(predicate, true_value, false_value)

    define(df, z=if_else('x>1', 1, 0))
    df >> define(z=if_else('x>1', 1, 0))

### query
query(data, expr)

    df >> query('z==1')

### ply
ply is pipe operator, equal to >>

    (df 
     >> define(z=if_else('x>1', 1, 0)) 
     >> query('z==1')
    )
    #is equal to 
    ply(df,
        define(z=if_else('x > 1', 1, 0)),
        query('z == 1')
    )

## async & Await
feature for python >=3.5

    async def ping_server(ip):
        # ping code here...

    async def ping_local():
        return await ping_server('192.168.1.1')

## divmod
 performs a modulus division % on two numbers, then returns both the quotient and remainder
## casefold
casefold provides standardize, more aggressively, a wider range of characters to lower case.
in most cases it is same as lower, but in some cases not

    "ς".casefold() # returns "σ"
    "ς".lower() # returns "ς"

## For/Else Statements
else will run if no break occurs

    for x in range(3):
    if x ==4 :
        break
    else:
    print('We never broke out')

## Queue Module
there are three types of Queue: FIFO, LIFO, and Priority Queue.
1) FIFO

    import queue

    # queue.Queue()
    q = queue.Queue()
    for i in range(5):
        q.put(i)
    while not q.empty():
        print(q.get())
    # result: 0,1,2,3,4

    # queue.SimpleQueue()
    simple_q = queue.SimpleQueue()
    for i in range(5):
        simple_q.put(i)
    while not simple_q.empty():
        print(simple_q.get())
    # result: 0,1,2,3,4

    q = queue.Queue(maxsize=3)
    try:
        for i in range(5):
            q.put(i, block=False)
    except queue.Full:
        print("Queue is Full with 3 items.")
    try:
        for i in range(5):
            print(f"element {q.get(block=False)}")
    except queue.Empty:
        print("Queue is already empty")

2) LIFO
LIFO is also named as stack.

    import queue

    q = queue.LifoQueue()
    for i in range(5):
        q.put(i)

    while not q.empty():
        print(q.get())
    # result: 4,3,2,1,0

    q = queue.LifoQueue(maxsize=3)
    try:
        for i in range(5):
            q.put(i, block=False)
    except queue.Full:
        print("Queue is Full with 3 items")
    try:
        for i in range(5):
            print(f"element {q.get(block=False)}")
    except queue.Empty:
        print("Queue is already empty")

3) Priority Queue
priority queue uses min heap queue algorithm. priority queue not only work with numbers but also complex data types like tuple or customized classes as long as the objects are comparable. dataclass with config order=True can make complex data struct comparable


    import queue
    q = queue.PriorityQueue()

    for i in [4,1,3,2,0]:
        q.put(i)
    while not q.empty():
        print(q.get())

    #complex struct
    from dataclasses import dataclass
    from typing import Any

    @dataclass(order=True)
    class Item:
        key: int
        value: Any

    q = queue.PriorityQueue()

    for i in [Item(3,"leiden"),Item(1,"amsterdam"),Item(2,"rotterdam"),Item(1,"utrecht")]:
        q.put(i)
    while not q.empty():
        print(q.get())

### user case
Queue is designed for multi-threading with following characteristics:
* thread-safe characteristic
* avoid potential memory explosion
* reduce busy waiting


    import queue
    import threading
    import random
    import requests

    def download(queue):
        id = queue.get()
        result = requests.get(f"https://jsonplaceholder.typicode.com/photos/{id}")
        url = result.json()["thumbnailUrl"]
        save_image(id, url)
        print(f"Save image {id}")
        queue.task_done() # this is new 
        
    NUM_THREADS = 10
    q = queue.Queue()

    for i in range(NUM_THREADS):
        worker = threading.Thread(target=download,args=(q,))
        worker.start()

    for i in range(NUM_THREADS):
        id = random.randint(1,100)
        q.put(id)

    q.join()

## numpy
### broadcasting
if numpy operate on two array of different size, the smaller array becomes broadcast across teh larger array if the dimension of smaller array is 1. otherwise exception is thrown
### slicing
array slicing is one shallow copy of original array

    originalArray= np.arange(0,10)
    #subArray is only a reference to original array
    subArray=originalArray[5:]
### linspace

    #endpoint is boolean whether to include the stop num or not
    np.linspace(start, stop, num, endpoint)
### size and type

    array= np.arrange(0,10)
    array.size
    array.dtype
    array.shape
    array.ndim

### cache value

    from functools import lru_cache
    @lru_cache(maxsize=1000)
    def fibonacci(input_value):
        if input_value ==1:
            return 1
        elif input_value == 2:
            return 1
        elif input_value > 2:
            return fibonacci(input_value-1)+fibonacci(input_value-2)

## load local env
create .env file in local path and save local env viriables in this file, e.g. GG_API_KEY=**INSERT API TOKEN**. 
To load these env variable in python environments:

    from  dotenv import load_dotenv
    load_dotenv()

## new features in python 3.8.5

### Assignment operator ( := )
A new syntax := that assigns values to variables as part of a larger expression

    if (n := len(a)) > 10:
        print(f"List is too long ({n} elements, expected <= 10)")

### Positional-only parameters ( / )

    #a and b are positional-only parameters,c and d can be positional or keyword, and e and f are required to be keywords
    def (a,b,/,c,d,*,e,f)
        print(a,b,c,d,e,f)
