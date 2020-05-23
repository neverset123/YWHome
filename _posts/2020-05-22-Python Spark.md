---
layout:     post
title:      tensorflow Random Forest
subtitle:   
date:       2020-05-22
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - Spark
    - high performance computations
---

spark is a framework for big data calculation
## attributes
* RDD: distributed data set for paralle computation
* memory sharing between tasks
    + broadcast
        var=sc.broadcast([1,2,3])
        print(var.value)
    + accumulator
        accum=sc.accumulator(0)
        sc.parallelize([1,2,3,4]).foreach(lambda x:accum.add(x))
## partition structure

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20180706010015323.png)
relationship between rdd, partition and task
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20180706005211170.png)
* job is submited when an action is trigered, jobs are done sequentially
* stage: one job contains many stages, stages are seperated by shuffle, which is dependency betwwen parent rdd and children rdd. stages are done sequentially
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20180706005229905.png)
* task: task is the smallest calculation element in spark. the number of tasks is actually the parallelism of stages 

## sparkconf
set configuration for sparks

    from pyspark import SparkContext, SparkConf
    conf=SparkConf()
    conf.setMaster('local').setAppName('My App') #local  is only for spark computation on local machine. if on cluster then leave it out, this parameter will be passed in command line with '--master' option

## sparkcontext
it is an interface to call APIs in spark

    sc=SparkContext(conf=conf)

## RDD
RDD is an abstract data type in spark, is similar to array. It is stored partitionedly

* using parallelied aggregation

    rdd=sc.parallelize(range(9),1)
    print(rdd.collect())

* using local file or hdfs

    lines=sc.textFile(path)
    words=lines.flatMap(lambda line:line.split(" "))
    keyvalue=words.map(lambda word:(word,1))
    print(keyvalue.countByKey())

## transformation

* map
processing input with specific operation and return result object

    rdd=sc.parallelize(range(9),1)
    print(rdd.map(lambda x:x).collect())
    print(rdd.map(lambda x:x+1).collect())

* mapPartitions(func, preservesPartitioning=False)
applying func on every slice rdd

* flatMap
map + flatten(concatenate all objects to one objects)

    rdd=sc.parallelize([1,2,3])
    print(rdd.map(lambda x: range(x)).collect())
    print(rdd.flatMap(lambda x: range(x)).collect())

* flatMapValues(f)
flat the value map without changing the key

    def func(x): return x
    sc.parallelize([("a",["x","y","z"]), ("b",["p","r"])]).flatMapValues(func).collect()

* mapValues
processing value with an operation

    rdd=sc.parallelize([("python", 1), ("c++", 2)])
    print(rdd.map(lambda x:x).collect())
    print(rdd.mapValues(lambda x:x*2).collect())

* filter
filter with condition

    rdd.filter(lambda x:x%2==0).collect()

* distinct
remove duplicates

    rdd.distinct().collect()

* randomSplit
slice data with portion

    rddsplitted=rdd.randomsplit([0.2, 0.6])
    print(rddsplitted[0].collect())

* groupBy
grouping by condition

    rddgrouped=rdd.groupBy(lambda x: "less" if(x<10) else "more")
    print(rddgrouped.mapValues(list).collect())

* groupbykey
group by key

* reduceByKey
processing element with same key with one operation

    rdd.reduceByKey(add).collect()

* sortBy(keyfunc, ascending=True, numPartitions=None)
sorting rdd with defined element( key or value)

    rdd.sortBy(lambda x: x[0]).collect() # sort by key
    rdd.sortBy(lambda x: x[1]).collect() # sort by value

* sortByKey

* aggregate(zeroValue, seqOp, combOp)
process zeroValue and element in rdd in first slice with seqOp, then operate results data from each slice with combOp

    seqOp=(lambda x,y: (x[0]+y, x[1]+1))
    combOp=(lambda x,y: (x[0]+y[0], x[1]+y[1]))
    sc.parallelize([1,2,3,4]).aggregate((0,0), seqOp, comOp)

* aggregateByKey(zeroValue, seqOp, combOp, numPartitions=None, partitionFunc=None)
aggregate value when key is the same and additionally zeroValue is added to the value

    seqOp=(lambda x,y: x+y)
    combOp=(lambda x,y: x+y)
    sc.parallelize([(1,2),(1,3),(1,4)]).aggregateByKey(3,seqOp, combOp).collect()

* join(rdd, numPartitions=None)
combining value in list with same key

    rdd1=sc.parallelize([("a", 1), ("b",1)])
    rdd2=sc.parallelize([("a", 3), ("b",4)])
    rdd1.join(rdd2).collect()

## action
it get elements in rdd, return to drive and triger the spark job and transformation

* reduce
reduce dimension with an operation

    rdd.reduce(add)

* collect
get the list of all elements in rdd to local client

* count
count number of elements in list

* take(n)
get first n elements from rdd

* first()
get first element from rdd

* top(n)
get n max elements from rdd

* takeOrdered(n, [, key=None])
get first n elements from rdd after sorting

* min, max, mean, stdev
* fold
initialize zeroValue in each slice and let zeroValue participat in op calculation, at the end the result in every slice will be combined into one slice(zeroValue also participate in calculation)

    addOp=(lambda x,y:x+y)
    rdd1=sc.parallelize(range(6), 1)
    rdd2=sc.parallelize(range(6),2)
    print(rdd1.fold(1,addOp))
    print(rdd2.fold(1,addOp))

* countByKey()
count elements with same key
* countByValue()
count elements with same value
* takeSample(bool,n)
bool:true->sampling with replacement; false->sampling without replacement
n: number of sample to be taken

    rdd.takeSample(true, 4)
* foreach or items()
loop through all element in rdd

* glom()
combining elements in different slice into one rdd list

* saveAsTextFile
save elements in rdd to file
* textFile
load text to memory

    sc.textFile(path)

* write.csv(path, mode="overwrite")

## shuffle
the process to gather datas on different nodes to one node with specific rule is called shuffle

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Imgv2-8b63c3d351fdb992fe9cbcec0466b50b_1440w.jpg)
* shuffle read 
is also called Map Task in mapReduce Shuffle
* shuffle write
is also called Reduce Task in mapReduce Shuffle

## persist
* persist() or cache()
store transformation result in memory for second usage

    variable.persist() # keep this variable in memory
    #or
    variable.cache()

* unpersist()
    variable.unpersist()


## run spark python script 

    spark-submit script.py

