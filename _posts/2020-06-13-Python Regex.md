---
layout:     post
title:      python regex
subtitle:   
date:       2020-05-22
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - regular expression
---

regex represents regular expression, which is a character pattern in searching

## Sets of matching characters
match for one or another character within a group, the group is defined with squre bracket

    import re
    #match a or A
    pattern = re.compile(r'[aA]', flags=re.IGNORECASE)
    #or
    pattern = re.compile(r'[a,A]', flags=re.IGNORECASE)
    #match anything between a and z or A and Z, length is not limited
    pattern = re.compile(r'[a-z]', flags=re.IGNORECASE)
    #match email consist of letters and numbers in .com domain
    pattern = re.compiler(r'[a-zA-Z0-9]+@+[a-zA-Z]+\.com')

## negation
NOT operation,search pattern except the ones that listed

    pattern = re.compile(r'[^a-z]', flags=re.IGNORECASE)

## special character and shortcuts
    \w — any single letter, digit or underscore

    \W — matches anything not covered with \w

    \d — matches numerical digits 0–9

    \D — Matches all non-digit characters(letters)

    \s — Matches whitespace (including tabs)

    \S — Matches non-whitespace

    \n — Matches new lines

    \r — Matches carriage returns

    \t — Matches tabs
    . -any single character except the newline character


## match quantities
    * — Zero or more
    + — One or more
    ? — Zero or one
    {n} — Exactly ’n’ number
    {n,} — Matches ’n’ or more occurrences
    {n,m} — Between ’n’ and ‘m’
    {m,n}? - m to n copies of RE to match in a non-greedy fashion

## regex built-in methods

* match
    prog=re.compile(r'ing')
    words=['Spring','cycling','Ringtone']
    for w in words:
        #if match then return an object, otherwise return None
        if prog.match(w,pos=len(w)-3)!=None:
            print('last three letters are ing')

* search
returns the matched object, apply group() method on the object to get teh matched string
    match_obj=prog.search(w)
    start=match_obj.span()[0]
    end=match_obj.span()[1]
    matched_string=match_obj.group()

* findall
returns a list with the matching pattern
* finditer
returns an iterator of the matched objects
* split
used to get rid of extrinsic characters which messing up a regular sent
    #replace ';,space_' from text
    " ".join(re.split('[;,\s_]+', text))

### matching string
* ^(cart) pattern at the beginning of a string not anywhere else

    pattern=re.compile(r'^Com')
* $ (dollar sign) matches a pattern at the end of the string
    pattern=re.compile(r'ing$')

## others
### combining multi-pattern
   #p0 and p1 are two patterns before compile
    pattern=p0+'|'+p1