---
layout:     post
title:      linux anacron
subtitle:   
date:       2021-04-03
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - linux
---

cron is a tool for automation job on linux.

## installation

    #check installation, if not exist it can be installed from distro's software repository
    $ which anacron
    /usr/sbin/anacron

## usage

#create example task script with content:
#!/bin/sh
touch /tmp/hello

#create cron directory
$ mkdir -p ~/.local/etc/cron.daily ~/.var/spool/anacron
#put example task script in cron.daily directory. you can add weekly, fortnightly, or even monthly directories to ~/.local/etc to schedule a wide variety of intervals, the configuration in ~/.local/etc/anacrontab should be changed accordingly. 
$ cp example ~/.local/etc/cron.daily
#chmod +x ~/.local/etc/cron.daily/example

#To configure anacron to run your cron jobs, create a configuration file at ~/.local/etc/anacrontab:
SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
1  0  cron.mine    run-parts /home/tux/.local/etc/cron.daily/

#Verify your anacrontab file's syntax:
$ anacron -T -t ~/.local/etc/anacrontab \
-S /home/tux/.var/spool/anacron

#Adding anacron to .profile, The -fn options tell anacron to ignore timestamps for test purpose, afterward you should remove that option
anacron -fn -t /home/tux/.local/etc/anacrontab \
-S /home/tux/.var/spool/anacron

## tips
### use cron with docker
1. Using the Host’s Crontab

    #start a docker container to execuate task.sh every 5 mins
    */5 * * * * docker run --rm example_app_image:latest /example-scheduled-task.sh

2. Using Cron Within Your Containers

    #create a file named crontab
    */5 * * * * /usr/bin/sh /example-scheduled-task.sh
    #create a docker image with this cron file
    RUN apt-get update && apt-get install -y cron
    COPY example-crontab /etc/cron.d/example-crontab
    RUN chmod 0644 /etc/cron.d/example-crontab &&\
        crontab /etc/cron.d/example-crontab

3. Separating Cron From Application’s Services
with a docker-compose file it is possible to start two docker containers: one for cron, one for application service.

    version: "3"
    
    services:
    app:
        image: demo-image:latest
        volumes:
        - data:/app-data
    cron:
        image: demo-image:latest
        entrypoint: /bin/bash
        command: ["cron", "-f"]
        volumes:
        - data:/app-data
    
    volumes:
    data:

4. run cron jobs on kubernetes

    apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
    name: my-cron
    namespace: my-namespace
    spec:
    schedule: "*/5 * * * *"
    concurrencyPolicy: Forbid
    jobTemplate:
        spec:
        template:
            spec:
            containers:
                - name: my-container
                image: my-image:latest
                command: ["/bin/bash", "/my-cron-script.sh"]
            restartPolicy: OnFailure

