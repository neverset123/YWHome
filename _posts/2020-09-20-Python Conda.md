---
layout:     post
title:      python conda
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
    - conda
---

this article is to describe how to use conda in docker

## activate conda

        FROM continuumio/miniconda3
        WORKDIR /app

        # Create the environment:
        COPY environment.yml .
        RUN conda env create -f environment.yml

        # Make RUN commands use the new environment:
        SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

        # Make sure the environment is activated:
        RUN echo "Make sure flask is installed:"
        RUN python -c "import flask"

        # The code to run when container is started:
        COPY run.py .
        ENTRYPOINT ["conda", "run", "-n", "myenv", "python", "run.py"]

## compress docker image
conda-pack is a tool that let’s you package a Conda environment into a standalone environment, with no need for the Conda toolchain

        # The build-stage image:
        FROM continuumio/miniconda3 AS build

        # Install the package as normal:
        COPY environment.yml .
        RUN conda env create -f environment.yml

        # Install conda-pack:
        RUN conda install -c conda-forge conda-pack

        # Use conda-pack to create a standalone enviornment
        # in /venv:
        RUN conda-pack -n example -o /tmp/env.tar && \
        mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
        rm /tmp/env.tar

        # We've put venv in same path it'll be in final image,
        # so now fix up paths:
        RUN /venv/bin/conda-unpack


        # The runtime-stage image; we can use Debian as the
        # base image since the Conda env also includes Python
        # for us.
        FROM debian:buster AS runtime

        # Copy /venv from the previous stage:
        COPY --from=build /venv /venv

        # When image is run, run the code with the environment
        # activated:
        SHELL ["/bin/bash", "-c"]
        ENTRYPOINT source /venv/bin/activate && \
                python -c "import numpy; print('success!')"
