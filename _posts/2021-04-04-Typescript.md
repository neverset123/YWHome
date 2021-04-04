---
layout:     post
title:      typescript
subtitle:   
date:       2021-04-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - frontend
---

## develop and publish npm package
1. register an account on npmjs.com.
2. npm adduser 
3. npm publish --dry-run
4. npm publish

## test framework

### mocha

    #installation
    npm i -D ts-mocha mocha chai @types/mocha @types/chai
    #add test coverage
    npm i nyc -D
    #add following content to .nycrc.json
    {
        "cache": false,
        "check-coverage": true,
        "extension": [
        ".ts"
        ],
        "include": [
        "**/src/*.ts"
        ],
        "reporter": [
        "cobertura",
        "text-summary"
        ],
        "statements": 90,
        "branches": 90,
        "functions": 90,
        "lines": 90
    }    

### static test
#### SonarCloud
static code analyzer that scans your source code and assesses metrics like maintainability, reliability, duplication, and also identifies security issues.
