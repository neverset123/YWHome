---
layout:     post
title:      data version control
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    - data engineering
---

dvc is command-line tool similar with git to help researcher govern their data

### environment

    python -m pip install dvc

### workflow

    #initialize to genetate .dvc folder
    dvc init
    #deactivate analysis configuration
    dvc config core.analytics false
    #add remote repo for dvc
    dvc remote add -d remote_storage path/to/your/dvc_remote
    #add track files
    dvc add data/raw/train
    dvc add data/raw/val
    #upload to remote
    dvc push
    #pull data from remote
    dvc pull
    #check dvc status
    dvc status

### Share a Development Machine

    #create cache folder
    dvc cache dir path/to/shared_cache

### DVC pipeline
pipeline consists of three stages: 
Inputs
Outputs
Command

    # remove manuelly added .dvc files to avoid confusion
    dvc remove data/prepared/train.csv.dvc \
        data/prepared/test.csv.dvc \
        model/model.joblib.dvc --outs
#### dvc run
dvc run needs 
Dependencies: prepare.py and the data in data/raw
Outputs: train.csv and test.csv
Command: python prepare.py

    #-n: stage name; -d:dependencies; -o: outputs
    #DVC will create two files, dvc.yaml and dvc.lock
    dvc run -n prepare \
        -d src/prepare.py -d data/raw \
        -o data/prepared/train.csv -o data/prepared/test.csv \
        python src/prepare.py
    
    #define evaluation stage
    #-M: to indicate metric to measure performance of the model
    dvc run -n evaluate \
        -d src/evaluate.py -d model/model.joblib \
        -M metrics/accuracy.json \
        python src/evaluate.py
#### dvc repro
DVC checks all the dependencies of the entire pipeline to determine what’s changed and which commands need to be executed again

    dvc repro evaluate
    #show metric accuracy
    dvc metrics show
