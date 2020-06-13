---
layout:     post
title:      python regex
subtitle:   
date:       2020-05-22
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - regex
---

regex represents regular expression, which is a character pattern in searching

## character class
search for one or another character within a group, the group is defined with squre bracket

    import re
    #search a or A
    pattern = re.compile(r'[aA]', flags=re.IGNORECASE)
    #search range
    pattern = re.compile(r'[a-z]', flags=re.IGNORECASE)
    re.findall(pattern,text)

## negation
NOT operation,search pattern except the ones that listed

    pattern = re.compile(r'[^a-z]', flags=re.IGNORECASE)

## special character and shortcuts
\w — Matches word characters (includes digits and underscores)

\W — Matches what \w doesn’t — non-word characters

\d — Matches all digit characters — Digits are [0–9]

\D — Matches all non-digit characters(letters)

\s — Matches whitespace (including tabs)

\S — Matches non-whitespace

\n — Matches new lines

\r — Matches carriage returns

\t — Matches tabs

## match quantities
    * — Zero or more
    + — One or more
    ? — Zero or one
    {n} — Exactly ’n’ number
    {n,} — Matches ’n’ or more occurrences
    {n,m} — Between ’n’ and ‘m’
