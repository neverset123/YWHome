---
layout:     post
title:      python testing
subtitle:   
date:       2020-07-26
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## mutation test
Mutation testing algorithmically modifies source code and checks if any "mutants" survived each test

    #angle.py
    def hours_hand(hour, minutes):
        base = (hour % 12 ) * (360 // 12)
        correction = int((minutes / 60) * (360 // 12))
        return base + correction

    def minutes_hand(hour, minutes):
        return minutes * (360 // 60)

    def between(hour, minutes):
        return abs(hours_hand(hour, minutes) - minutes_hand(hour, minutes))

    #test_angle.py
    import angle

    def test_twelve():
        assert angle.between(12, 00) == 0
    
    # to run mutation test
    mutmut run --paths-to-mutate angle.py
    #check changes
    mutmut results
    #use mutmut apply to apply a failed test case
    mutmut apply 4
    # according the test done by mutation, you can modify your own test cases