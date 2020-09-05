---
layout:     post
title:      search engine
subtitle:   
date:       2020-09-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---
search engine mainly contain four steps: web scraping, indexing, searching in index db, ordering the search results.

during searching, TERM operator queries inverted list of every emerging word, AND operator converts inverted list into score list and do AND to document id sets in the score list to form a new score list. The score of each document is the product of document id score in all score list

## inverted list

### access mechanism
* b-tree
* Hash table

## Document Manager

## Term Dictionary



## score list
it records the score of documents that contains the searched word, it varies between 0 and 1

## multiple representation model   

## term frequency–inverse document frequency

## Sphinx
