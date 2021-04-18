---
layout:     post
title:      openshift
subtitle:   
date:       2021-04-17
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - big data
---


OpenShift is an enterprise-level container cloud PaaS platform launched by RedHat.The whole process of development, testing, deployment, operation and maintenance can be carried out on OpenShift, achieving a high degree of automation, meeting the needs of continuous integration, delivery and deployment of applications in enterprises, and also meeting the needs of enterprises for container management (docker) and container orchestration (k8s).
* Container engine: Docker provides a stable, reliable and efficient operating environment.
* Container orchestration: Kubernetes provides container orchestration components such as cluster management, high availability, security, and continuous integration to meet the scheduling, network, storage, performance, and security requirements of container clusters
* application-centric
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210418120029.png)

## comparision with k8s
* Deployment: OpenShift can be installed on RHEL (Red Hat Enterprise Linux) and RHELAH (Red Hat Eneterprise Linux Atomic Host), CentOS and Fedora; K8S is best run on Unbuntu, Fedora and Debian, and can be deployed on any major IaaS. On cloud platforms such as IBM, AWS, Azure, GCP, and Alibaba Cloud
* Rollout: OpenShift can be installed based on a proprietary installer such as Ansible with minimal configuration parameters; most of K8S is installed based on an installer such as Rancher Kubernetes Everywhere (RKE) or kops.
* WEB UI: OpenShift's Web UI has a login page. This UI can not manage clusters, but can visualize servers, projects and cluster roles; K8S's visual interface needs to be installed separately and needs to be accessed through kube proxy to forward the port of the local machine to The cluster management server. You need to manually create a bearer token to provide authentication and authorization
