---
layout:     post
title:      causal analysis
subtitle:   
date:       2021-12-10
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---


## causal-learn

```#install causal-learn
pip install causal-learn
#causal discovery
G = pc(data, alpha, indep_test, stable, uc_rule, uc_priority, mvpc, correction_name, background_knowledge)
#visualization
G.to_nx_graph()
G.draw_nx_graph(skel=False)
```