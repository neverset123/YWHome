---
layout:     post
title:      distributed filesystem
subtitle:   
date:       2020-11-16
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data enginerring
---

simpliest distributed implementation is NFS with Helm chart, but there are some limitations such as share storage between pods  and poor scaling ability

## GlusterFS and CephFS
open-source software-defined storage (SDN) systems
components:
* Gluster Servers
storage bricks
* Gluster Clients
* Management API
abstracting low-level volumes manipulation. 
there is a better option named Heketi for volume management

### partition disk

    $ apt-get install grml-rescueboot
    $ cd /boot/grml
    $ wget http://download.grml.org/grml64-small_2020.06.iso
    $ update-grub
    #resize existing system
    $ fsck.ext4 -f /dev/vda1
    $ resize2fs -M /dev/vda1
    $ parted /dev/vda
    $ resizepart 1 30G # shrink vda1 to 30 Gb
    $ mkpart gluster 30001 100% # create vda3 where vda1 ends
    $ set 3 lvm on # optionally setup logical volumes
    $ print # verify results
    $ quit

### link storage via symlink

    $ ls -altr /dev/disk/* | grep <device>

### Setting Up Gluster Client

    $ modprobe dm_thin_pool
    $ echo dm_thin_pool | tee -a /etc/modules
    dm_thin_pool # verify output
    #setting up a client version to server version
    $ wget -O - https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add - # install certificate
    $ echo deb [arch=amd64] https://download.gluster.org/pub/gluster/glusterfs/7/7.1/Debian/buster/amd64/apt buster main > /etc/apt/sources.list.d/gluster.list
    $ apt-get update
    $ apt-get install glusterfs-client
    $ /usr/sbin/glusterfs --version

### deploying server and Heketi API

    topology:
        clusters:
            - nodes:
                - node:
                    hostnames:
                        manage:
                        - kicksware-k8s-3pdt3
                        storage:
                        - 10.114.0.5
                    zone: 1
                    devices:
                    - /dev/disk/gluster-disk
                - node:
                    hostnames:
                        manage:
                        - kicksware-k8s-3pdt8
                        storage:
                        - 10.114.0.3
                    zone: 1
                    devices:
                    - /dev/disk/gluster-disk
                - node:
                    hostnames:
                        manage:
                        - kicksware-k8s-3pdtu
                        storage:
                        - 10.114.0.4
                    zone: 1
                    devices:
                    - /dev/disk/gluster-disk

