---
layout:     post
title:      algorithm pattern
subtitle:   
date:       2020-09-25
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - algorithm
---

this artical will introduce 14 common algorithm modes

## sliding window

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/20000003030330303030.jpg)

sliding window usually used to solve probelm:
* max sum of sub-array with size of K
* longst sub-string with K different letters
* find word in string 

## double pointers

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/200003224230432405.jpg)

double pointer used to solve problem with restractions in ordered array or linked list
*  Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero
* check equality of two strings

## fast-slow-pointer

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/200000345353453.jpg)
 
 fast-slow-pointer used to solve problem for array cycle or linked list cycle
 * check cycle in linked list
 * check Palindrome in linked list
 * find cycle in array cycle

 ## Interval merge

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/20000002434343543.jpg)

interval merge used to solve insert or merge in interval problem
* Interval intersection
* Maximize CPU load

## cycle sorting

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/200000424234234.jpg)

cycle sorting used to solve problem that in ordered array in specified range
* find digital not existing in array
* find min. number not existing in array

## linked list flip

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/200000343534546.jpg)

fliping used to solve linked list problem without extra memory
* Flip part of linked list
* Flip sub linked list with size K

## BFS tree

BFS to search over a tree over layer
* binary tree sequence search
* zigzag search

## DFS tree
 
DFS used to solve problem that has a solution near leaf node
* digital sum of all path on tree
* all paths the have a defined sum

## Double heap

* scheduling problem
* find max, min or medium

## Sub-set

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/2000453543534634.jpg)

used to solve problem in Permutation and combination
* All subsets with repeating elements
* find all permutation with changing case


## binary search variant

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/2000000423425325345.jpg)

## find k max

data structure is heap or priorityqueue
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/20000235234646456464.jpg)

## K merge

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/200004353645745765.jpg)

* merge K linked list

## Topological sort

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/2000043242353454754.jpg)
deal with graphs that have no directed cycles, or update all objects in a sorted order, or object following a particular order


* Task scheduling
* Minimum height of a tree