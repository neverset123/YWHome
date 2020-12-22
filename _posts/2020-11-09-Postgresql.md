---
layout:     post
title:      postgresql
subtitle:   
date:       2020-11-09
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
    - database
---

traditional RDBMS (relational database management system). Mainly used for relational data, it is object-oriented in nature.
## useful operation like in dataframe

* Specify your own custom functions
* Use recursion to create complex looping and data generation with the WITH keyword.
* Sort string columns by a substring.
* Perform complex joining between multiple tables.
* Use SQL to generate SQL (automating tasks).
* Generate forecasts using statistical models.
* Create histograms.
* Build tree structures (with leaf, branch, root nodes)

### select

    SELECT CustomerName || ' LIVES IN ' || Address || ', ' || City AS location
    FROM Customers
    WHERE Country='Mexico'

### if/else

    SELECT Price,
        CASE WHEN Price < 12 THEN 'Cheap'
            WHEN Price < 21 THEN 'Regular'
                ELSE 'Expensive'
        END AS Bucket
    FROM Products

### random select

    SELECT * FROM Products ORDER BY random() LIMIT 5

## usage tips
### postgresql cluster
Create a unified management, flexible cloud-native production deployment to deploy a personalized database as a service (DBaaS).

    #config postgresql operator
    wget <https://raw.githubusercontent.com/CrunchyData/postgres-operator/master/examples/quickstart.sh>
    chmod +x ./quickstart.sh
    ./examples/quickstart.sh

    #create postgresql cluster
    pgo create cluster mynewcluster
    pgo test mynewcluster



### monitoring postgres on kubernetes

    #deploy monitoring pod
    kubectl apply -f https://raw.githubusercontent.com/CrunchyData/postgres-operator/v4.5.0/installers/metrics/kubectl/postgres-operator-metrics.yml
    #collect data
    pgo create cluster hippo --metrics --replica-count=1
    pgo create cluster rhino --metrics --replica-count=1
    pgo create cluster zebra --metrics