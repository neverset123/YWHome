---
layout:     post
title:      makefiles
subtitle:   
date:       2020-11-28
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---


## Makefiles for python
automatte some steps

    #to avoid using local clean-pyc file
    .PHONY: clean-pyc clean-build
    
    HOST=127.0.0.1
    TEST_PATH=./

    clean-pyc:
        #plus sign means that the total number of invocations of the command will be much less than the number of matched files
        find . -name '*.pyc' -exec rm --force {} +
        find . -name '*.pyo' -exec rm --force {} +
        name '*~' -exec rm --force  {}

    clean-build:
        rm --force --recursive build/
        rm --force --recursive dist/
        rm --force --recursive *.egg-info

    isort:
        sh -c "isort --skip-glob=.tox --recursive . "

    lint:
        flake8 --exclude=.tox

    test: clean-pyc
        py.test --verbose --color=yes $(TEST_PATH)

    run:
    python manage.py runserver --host $(HOST) --port $(PORT)

    docker-run:
        docker build \
        --file=./Dockerfile \
        --tag=my_project ./
        docker run \
        --detach=false \
        --name=my_project \
        --publish=$(HOST):8080 \
        my_project
    
    @echo "    clean-pyc"
    @echo "        Remove python artifacts."
    @echo "    clean-build"
    @echo "        Remove build artifacts."
    @echo "    isort"
        Sort import statements.
    @echo "    lint"
    @echo "        Check style with flake8."
    @echo "    test"
    @echo "        Run py.test"
    @echo '    run'
    @echo '        Run the `my_project` service on your local machine.'
    @echo '    docker-run'
    @echo '        Build and run the `my_project` service in a Docker container.'