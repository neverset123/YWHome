---
layout:     post
title:      python jupyter
subtitle:   
date:       2020-09-06
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## remote management console
start jupyter notebook on remote host, and port forwards it to local host. then you can start console, read/write file and update data

    #on remote host
    jupyter notebook
    #on local host
    ssh -L 8111:127.0.0.1:8888 username@hostname