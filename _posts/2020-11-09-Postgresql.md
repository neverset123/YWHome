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
---

## monitoring postgres

    #deploy monitoring pod
    kubectl apply -f https://raw.githubusercontent.com/CrunchyData/postgres-operator/v4.5.0/installers/metrics/kubectl/postgres-operator-metrics.yml
    #collect data
    pgo create cluster hippo --metrics --replica-count=1
    pgo create cluster rhino --metrics --replica-count=1
    pgo create cluster zebra --metrics