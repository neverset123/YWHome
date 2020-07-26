---
layout:     post
title:      python regex
subtitle:   
date:       2020-06-14
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

### Look-ahead/behind Assertions - (?>= ) | (?= ) | (?>! ) | (?! )

(?>= ): behind assertion
 (?= ): before assertion
(?>! ): not behind assertion
(?! ): not before assertion

#searching username in the following html
<a href="/@jamescalam?source=post_page-----22e4e63463af----------------------" class="cg ch au av aw ax ay az #ba bb it be ck cl" rel="noopener">James Briggs</a>

    if bool(re.search(r'(?=<\/)'@.*(?=\?source)', a)):
        username = re.search(r'(?=>\/)'@.*(?=\?source)', a).group()

### Modifiers - (?sm)

Single line [s] - Allows the . metacharacter (which matches everything except newlines) to match newlines   tooMulti-line [m] - ^ and $ now match the beginning/end of lines, rather than default behavior of matching beggining/end of entire stringInsensitive [i] - Upper and lower-case characters are matched, e.g. A = a  
Extended [x] - Ignores whitespace. To include spaces, they must be escaped using \. Also allows comments inside the regex with #    
ASCII [a] - Match to ASCII-only characters, rather than the full Unicode character set

    #Adding both the single line and insensitive modifiers using modifier flags
    re.match('[a-z]+01.*', text, re.S|re.I)
    #or adding inline modifier with  the (? ) syntax within the expression
    #the modifier can be turn off by (?- ), but it is not supported in python
    re.match('(?si)[a-z]+01.*', text)


### Conditionals (If|Else) - (...)?(?(1)True|False)

    for t in text:
        print(re.search(r"hello)?(?(1) world| bye)!", t)