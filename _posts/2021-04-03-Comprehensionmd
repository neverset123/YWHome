---
layout:     post
title:      comprehension
subtitle:   
date:       2021-04-03
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## List Comprehension

my_list = [<expression> for <item> in <iterable> if <condition>]

## Dictionary Comprehension

my_dict = [<key>:<value> for <item> in <iterable> if <condition>]

e.g. data_employees = {p['name']:p['title'] for p in persons if 'Data' in p['title']}

## Set Comprehension

my_set = {<expression> for <item> in <iterable> if <condition>}

e.g. data_employees_set = {p['name'] for p in persons if 'Data' in p['title']}

## data_employees_set = {p['name'] for p in persons if 'Data' in p['title']}

my_gen = (<expression> for <item> in <iterable> if <condition>)

e.g.eg = (int(number/2) for number in my_list if number % 2 == 0)
    print(next(eg))

## Nested Comprehension

e.g. print('\n'.join([''.join([f'{col}x{row}={row*col} \t' for col in range(1, row + 1)]) for row in range(1, 10)]))

