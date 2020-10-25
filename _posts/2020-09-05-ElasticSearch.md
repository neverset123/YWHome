---
layout:     post
title:      ElasticSearch
subtitle:   
date:       2020-09-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---

ElasticSearch is an open-source search engine, which is not only for log analysis, but also support any other data search, search, and collection scenarios. It is based on Lucene library, and provide Restful API. Its searching performance is almost real time (<1s)
it consists of three components:
* ElasticSearch
* Logstash
* Kibana

## basics
### node and cluster
ElasticSearch acts like a distributed database, there can be multi- elastic instances on one server. one elastic instance is called one node, a group of nodes are called cluster.

### Index
elastic indexes all fields and write back an Inverted Index. During searching it searches directly in the inverted index. Index here means a small database, its name must be lowercased

    #get all index on current node
    curl -X GET 'http://localhost:9200/_cat/indices?v'

### Document
one record in index is called Document, Index is consist of multi-Documents. Documents in the same index can have different scheme.

    #Document example
    {
        "user": "Tom",
        "title": "Engineer",
        "desc": "Management"
    }

### Type
Documents can be grouped by types, which is used for filtering.
different types should have similar scheme

    #get all types in one index
    curl 'localhost:9200/_mapping?pretty=true'
### field
attributes of documents

## CRUD
### Create & Delete Index

    #create index
    curl -X PUT 'localhost:9200/weather'
    #delete index
    curl -X DELETE 'localhost:9200/weather'

### mapping
mapping is scheme of index, which can be defined manually or automatically by ES

    #create mapping
    PUT /index/_mapping
    {
        "properties": {
            "field_name": {
                "type": "text",
                "index": true，
                "store": true，
                "analyzer": "ik_max_word"
            }
        }
    }
    #get all mapping
    get http://192.168.116.129:9200/_mapping

### Create record

    #insert one record in /Index/Type/id_value
    curl -X PUT 'localhost:9200/accounts/person/1' -d '
    {
        "user": "Tom",
        "title": "Engineer",
        "desc": "Management"
    }' 

### Read Record

    #read record with /Index/Type/id_value
    curl 'localhost:9200/accounts/person/1?pretty=true'

### Delete Record

    #delete record with /Index/Type/id_value
    curl -X DELETE 'localhost:9200/accounts/person/1'

### Update record

    #update record with /Index/Type/id_value
    curl -X PUT 'localhost:9200/accounts/person/1' -d '
    {
        "user" : "Tom",
        "title" : "Engineer",
        "desc" : "Management, SW"
    }' 
### analyzer

    post http://192.168.116.129:9200/_analyze 
    {"text":"test tokenizer:cloud","analyzer":"ik_max_word" }

## Query data

    #get all records
    curl 'localhost:9200/accounts/person/_search'

### basic query
basic query follows pattern as belows:

    GET /index/_search
    {
        "query":{
            "query_type":{
                "query_condition":"condition_value"
            }
        }
    }

query_type includes: match_all， match，term, range

#### match all

    GET /dm/_search
    {
        "query":{
            "match_all": {}
        }
    }

#### match

    #query with or
    GET /dm/_search
    {
        "query":{
            "match":{
                "title":"smart phone"
            }
        }
    }
    #query with and
    GET /dm/_search
    {
        "query":{
            "match": {
            "title": {
                "query": "smart phone",
                "operator": "and"
            }
            }
        }
    }
    #query with minimum_should_match
    GET /dm/_search
    {
        "query":{
            "match":{
                "title":{
                    "query":"smart phone huawei",
                    "minimum_should_match": "75%"
                }
            }
        }
    }

#### term
used for precise matching

    GET /dm/_search
    {
        "query":{
            "term":{
                "price":2699.00
            }
        }
    }
    #precise matching with one in multi fields
    GET /dm/_search
    {
        "query":{
            "terms":{
                "price":[2699.00,2899.00,3899.00]
            }
        }
    }

### source filtering
ES stores search results under _source, we can filter these results in _source

#### specific field

    GET /dm/_search
    {
    "_source": ["title","price"],
    "query": {
        "term": {
        "price": 3899
        }
    }
    }
#### include & exclude

    GET /dm/_search
    {
    "_source": {
        "includes":["title","price"]
    },
    "query": {
        "term": {
        "price": 3899
        }
    }
    }

### advanced query
#### bool

    GET /dm/_search
    {
        "query":{
            "bool":{
                "must":     { "match": { "title": "phone" }},
                "must_not": { "match": { "title":  "watch" }},
                "should":   { "match": { "title": "TV" }}
            }
        }
    }
#### range

    GET /dm/_search
    {
        "query":{
            "range": {
                "price": {
                    "gte":  1000.0,
                    "lt":   4800.00
                }
            }
        }
    }

#### fuzzy

    GET /dm/_search
    {
        "query": {
            "fuzzy": {
            "title": "appla"
            }
        }
    }


### filter
this filter does not influence result ranking (main difference to source filtering)

    GET /dm/_search
    {
        "query":{
            "bool":{
                "must":{ "match": { "title": "phone" }},
                "filter":{
                    "range":{"price":{"gt":2000.00,"lt":3800.00}}
                }
            }
        }
    }

### sort
#### single field

    GET /dm/_search
    {
        "query": {
            "match": {
            "title": "phone"
            }
        },
        "sort": [
            {
            "price": {
                "order": "desc"
            }
            }
        ]
    }

#### multi field

    GET /goods/_search
    {
        "query":{
            "bool":{
                "must":{ "match": { "title": "phone" }},
                "filter":{
                    "range":{"price":{"gt":200000,"lt":300000}}
                }
            }
        },
        "sort": [
            { "price": { "order": "desc" }},
            { "_score": { "order": "desc" }}
        ]
    }

## aggregations
### basics
#### bucket
#### metrics
### Operation 
1. aggregate to bucket

    GET /cars/_search
    {
        "size" : 0,
        "aggs" : { 
            "popular_colors" : { 
                "terms" : { 
                "field" : "color"
                }
            }
        }
    }
2. matrice in bucket

    GET /cars/_search
    {
        "size" : 0,
        "aggs" : { 
            "popular_colors" : { 
                "terms" : { 
                "field" : "color"
                },
                "aggs":{
                    "avg_price": { 
                    "avg": {
                        "field": "price" 
                    }
                    }
                }
            }
        }
    }
3. bucket in bucket

    GET /cars/_search
    {
        "size" : 0,
        "aggs" : { 
            "popular_colors" : { 
                "terms" : { 
                "field" : "color"
                },
                "aggs":{
                    "avg_price": { 
                    "avg": {
                        "field": "price" 
                    }
                    },
                    "maker":{
                        "terms":{
                            "field":"make"
                        }
                    }
                }
            }
        }
    }