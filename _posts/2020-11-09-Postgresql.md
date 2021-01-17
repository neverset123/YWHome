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

## index

### hash index
Starting at PostgreSQL 10 these limitations were resolved, and Hash indexes are no longer discouraged.
Hash index outperforms the B-Tree index with a very slight difference, but it has a much smaller index size.
limitation:
* Hash index cannot be used to enforce a unique constraint
* Hash index cannot be used to create indexes on multiple columns
* Hash index cannot be used to create sorted indexes
* can't use a Hash index to cluster a table
* Hash index cannot be used for range lookups
* A Hash index cannot be used to satisfy ORDER BY queries

#### Creating Hash Indexes

    #an example of URL shortener service(provides a short random URL that points to a longer URL) 
    #table between key and full url
    CREATE TABLE shorturl (
    id serial primary key,
    key text not null,
    url text not null
    );
    #create a B-Tree and a Hash index on both fields (key and full url)
    CREATE INDEX shorturl_key_hash_index ON shorturl USING hash(key);
    CREATE UNIQUE INDEX shorturl_key_btree_index ON shorturl USING btree(key);

    CREATE INDEX shorturl_url_hash_index ON shorturl USING hash(url);
    CREATE INDEX shorturl_url_btree_index ON shorturl USING btree(url);

#### Hash Index Size
The Hash index is smaller than the B-Tree index.

    CREATE EXTENSION "uuid-ossp";
    DO $$
    BEGIN
        FOR i IN 0..1000000 loop
            INSERT INTO shorturl (key, url) VALUES (
            uuid_generate_v4(),
            'https://www.supercool-url.com/' || round(random() * 10 ^ 6)::text
        );
        if mod(i, 10000) = 0 THEN
            RAISE NOTICE 'rows:%  Hash key%  B-Tree key:%  Hash url:%  B-Tree url:%',
                to_char(i, '9999999999'),
                to_char(pg_relation_size('shorturl_key_hash_index'), '99999999999'),
                to_char(pg_relation_size('shorturl_key_btree_index'), '99999999999'),
                to_char(pg_relation_size('shorturl_url_hash_index'), '99999999999'),
                to_char(pg_relation_size('shorturl_url_btree_index'), '99999999999');
        END IF;
        END LOOP;
    END;
    $$;





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