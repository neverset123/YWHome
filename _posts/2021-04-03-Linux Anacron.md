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




