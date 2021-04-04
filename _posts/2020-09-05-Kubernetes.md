---
layout:     post
title:      kubernetes
subtitle:   
date:       2020-09-05
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---
kubernetes is a container automatic operation platform, which is used to manage deployment, scheduling and scaling between node clusters

    # to deploy pod on kubernetes using kind:deployment
    kubectl create -f deployment.yaml
    # to deploy or update pod on kubernetes
    kubectl apply -f https://k8s.io/examples/pods/two-container-pod.yaml

![](https://raw.githubusercontent.com/neverset123/cloudimg/master/202006242207.png)
## components

### job
Unlike deployments and services in Kubernetes, you can't change the same Job configuration file and reapply it at once. When you make changes in the Job configuration file, you must delete the previous Job from the cluster before you apply it.
Jobs are used to create transient pods that perform specific tasks they are assigned to. CronJobs do the same thing, but they run tasks based on a defined schedule

#### Jobs
creat jobs with a defined yaml file
#### CronJobs
execute job on a predefined schedule

    apiVersion: batch/v1beta1            ## The version of the Kubernetes API
    kind: CronJob                        ## The type of object for Cron jobs
    metadata:
    name: cron-test
    spec:
    schedule: "*/1 * * * *"            ## Defined schedule using the *nix style cron syntax
    jobTemplate:
        spec:
        template:
            spec:
            containers:
            - name: cron-test
                image: busybox            ## Image used
                args:
            - /bin/sh
                - -c
                - date; echo Hello this is Cron test
            restartPolicy: OnFailure    ##  Restart Policy in case container failed

#### Work queues


### pod
consist of a group of containers and volumes. container in the same pod share one namespace, so localhost communication is possible
pod is temporary and stateless rather than consistent. If exception happens, kubernetes will create new pod to replace old pod

### lable
lable is a key/value pair for user defined attributes transfer, which enables pod selection with Selectors and applies service or replication controller on the selection

### replication controller
replication controller creates multi-copies of a pod on nodes and constently watching them

### service
service defines a group of pods and an abstraction layer (virtual layer) for pod access. service can find a group of pods using lable, the access to the pod is also load-balanced managed

### node
node is kubernetes worker, key-components are kubelet (master node proxy), kube-proxy(with this service can connect to pod) and docker
#### master node
there are three core components in master node: kubectl-scheduler，etcd and controller-manager
* kubectl-scheduler: scheduling of resource objects
* etcd: Responsible for persisting resource objects in the cluster
* controller-manager: watch cluster status and decide for operation

### volume storage
* emptyDir: it is created when pod is distributed to node, all containers on this pod have read/write access to this volume. volume will be removed if pod is deleted from node(non-persistent)

    apiVersion: v1
    kind: Pod
    metadata:
        name: test-pd
    spec:
        containers:
        - image: k8s.gcr.io/test-webserver
            name: test-container
            volumeMounts:
            - mountPath: /cache
            name: cache-volume
        volumes:
        - name: cache-volume
            emptyDir: {}
* hostPath: it mount file system on Node onto pod. when pod need to use file no node, hostPath should be used. Typical user cases are saving logs into host, accessing docker's data on the host

    apiVersion: v1
    kind: Pod
    metadata:
        name: test-pd
    spec:
        containers:
        - image: k8s.gcr.io/test-webserver
            name: test-container
            volumeMounts:
            - mountPath: /test-pd
            name: test-volume
        volumes:
        - name: test-volume
            hostPath:
            #directory location on host
            path: /data
            #this field is optional
            type: Directory
* gcePersistentDisk: it mounts GCE's(google compute engine) persistent drive onto volume(need GCE VM)

    volumes:
        - name: test-volume
            # This GCE PD must already exist.
            gcePersistentDisk:
            pdName: my-data-disk
            fsType: ext4
* nfs

    volumes:
        - name: nfs
        nfs:
            # FIXME: use the right hostname
            server: 10.254.234.223
            path: "/"
* gitRepo

     volumes:
        - name: git-volume
            gitRepo:
            repository: "git@somewhere:me/my-git-repository.git"
            revision: "22f1d8406d464b0c0874075539c1f2e96c253775"

* subPath:mount share volume for multi-container

    apiVersion: v1
    kind: Pod
    metadata:
        name: my-lamp-site
    spec:
        containers:
        - name: mysql
            image: mysql
            volumeMounts:
            - mountPath: /var/lib/mysql
                name: site-data
                subPath: mysql
        - name: php
            image: php
            volumeMounts:
            - mountPath: /var/www/html
                name: site-data
                subPath: html
        volumes:
        - name: site-data
            persistentVolumeClaim:
                claimName: my-lamp-site-data
#### In-tree Volume Plugin
#### Out-of-tree Provisioner
#### CSI (Container Storage Interface)
csi is an abstract interface with protobuf protocol
##### RPC (remote procedure call protocol)
* call ID mapping      
every function has its own ID, this ID is unique in all processes. During remote call this ID will be sent from client to server, so that server can call this function according to this ID
* serialization and deserialization 
parameters will be converted to byte stream (serialization), send to server, and converted back to readable formate for server(deserialization)
* network transmission
using TCP, or UDP or HTTP2 for network transmission
##### PV and PVC
PV&PVC enable creating volume independent of pod, its lifecycle is also independent of pod
* provisioning  
    + static: VolumeManager create PVs
    + dynamic: VolumeManager define StorageClass, system will create PV and PVC combination automatically
* binding   
* Using 
pod use volume to mount pvc on the container. If volume type is persistentVoulumeClaim, then the PV resource is used exclusively
* release   
after deletion of PVC, PV will be released. After the data on PV is removed or deleted(reclaiming process) another binding is possible
* reclaiming
policy to deal with remaining data on PV after release 
###### PV(Persisten Volume)
is an abstraction of network storage. It is created and configurated by VolumeManager , and connects to share storage with plugin mechanism.
* it is network storage, does not belong to any node, but can be accessed  by every node
* it is defined outside Pod
* it can define storage capacity, access mode, storage class, reclaim Policy, storage type

    apiVersion: v1
    kind: PersistentVolume
    metadata:
        name: pv0001
    spec:
        capacity:
            storage: 5Gi  
        accessModes:
            - ReadWriteMany 
        persistentVolumeReclaimPolicy: Recycle
        storageClassName：slow
        nfs:
            path: "/data/disk1"
            server: 192.168.69.69 
            readOnly: false
###### PVC(PersistentVolumeClaims)
is a claim of resource consumption on PV. This claim is used by refering it unter volume in pod
* both PV and PVC are restricted to namespace, only PV and PVC under same namespace can be combined, PVC can only be mounted to Pod in the same namespace
* system will match PV and PVC which fulfill both storageclass and selector
* if PV is not defined by VolumeManager, then a ReadWriteOnce PV will be created dynamically by system. matching PV using selector is not possible any more

    #defining pvc statically
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
        name: myclaim
    spec:
        accessModes:
            - ReadWriteOnce
        # description of claimed resource
        resources:
            requests:
                storage: 8Gi
        # PVC storage class requirement, only matching PV will be selected 
        storageClassName: slow
        # setting selection lables to filter out PV
        selector:
            matchLabels:
                release: "stable"
            matchExpressions:
                - {key: evironment, operator: In, values: [dev]}
    #define pvc dynamically
    kind: StorageClass
    apiVersion: storage.k8s.io/v1
    metadata:
        name: slow
    provisioner: kubernetes.io/aws-ebs
    parameters:
        type: io1
        zones: us-east-1d, us-east-1c
        iopsPerGB: "10"
    #refering pvc
    kind: Pod
    apiVersion: v1
    metadata:
        name: mypod
    spec:
        containers:
            - name: myfrontend
            image: dockerfile/nginx
            volumeMounts:         #####Volume config
            - mountPath: "/var/www/html"
                name: mypd
        volumes:
            - name: mypd
            persistentVolumeClaim: ######
                claimName: myclaim   ##########

### Security Context
it defines the access rights of Pod and Container

#### Discretionary Access Control
define access rights according to UID(user ID) and GID(group ID)
    #security context for pod
    apiVersion: v1
    kind: Pod
    metadata:
        name: security-context-demo
    spec:
        securityContext:
            runAsUser: 1000
            fsGroup: 2000
        volumes:
        - name: sec-ctx-vol
            emptyDir: {}
        containers:
        - name: sec-ctx-demo
            image: gcr.io/google-samples/node-hello:1.0
            volumeMounts:
                - name: sec-ctx-vol
            mountPath: /data/demo
            securityContext:
            allowPrivilegeEscalation: false
    
    #security context for container
    apiVersion: v1
    kind: Pod
    metadata:
        name: security-context-demo-2
    spec:
        securityContext:
            runAsUser: 1000
        containers:
        - name: sec-ctx-demo-2
            image: gcr.io/google-samples/node-hello:1.0
            securityContext:
            runAsUser: 2000
            allowPrivilegeEscalation: false
#### Security Enhanced Linux (SELinux)
define SELinux labels for specific container

    securityContext:
        seLinuxOptions:
            level: "s0:c123,c456"

#### Running as privileged or unprivileged
define run as privileged or unprivileged

    apiVersion: v1
    kind: Pod
    metadata:
        name: security-context-demo-4
    spec:
    containers:
        - name: sec-ctx-4
            image: gcr.io/google-samples/node-hello:1.0
            securityContext:
            privileged: true
#### Linux Capabilities
assign privileged rights to certain processes rather than root user

    apiVersion: v1
    kind: Pod
    metadata:
        name: security-context-demo-4
    spec:
        containers:
        - name: sec-ctx-4
            image: gcr.io/google-samples/node-hello:1.0
            securityContext:
            capabilities:
                add: ["NET_ADMIN", "SYS_TIME"]
#### using sysctl
safe sysctl can be directly used in pod, but to use unsafe sysctl, experimental-allowed-unsafe-sysctls needs to be activated in kubelet
    # security context that belongs to safe sysctl:
    kernel.shm_rmid_forced
    net.ipv4.ip_local_port_range
    net.ipv4.tcp_syncookies

    #example of safe sysctl
    apiVersion: v1
    kind: Pod
    metadata:
        name: sysctl-example
    annotations:
        security.alpha.kubernetes.io/sysctls: kernel.shm_rmid_forced=1
    spec:...
    
    #example of unsage sysctl
    apiVersion: v1
    kind: Pod
    metadata:
        name: sysctl-example
        annotations:
            security.alpha.kubernetes.io/unsafe-sysctls: net.core.somaxconn=65535 
    spec:
        securityContext:
            privileged: true
        ...
### secret
* Opaque：using base64 to save secrets, which can be decoded with base64 --decode. its safety is relatively weak

        # for pod that has access to secret data through volume
        kubectl create secret generic test-secret --from-literal='username=my-app' --from-literal='password=39528$vdg7Jb'
        # Run this in the shell inside the container
        echo "$( cat /etc/secret-volume/username )"
        echo "$( cat /etc/secret-volume/password )"

        # Define container environment variables using Secret data
        kubectl create secret generic test-secret --from-literal=username='my-app' --from-literal=password='39528$vdg7Jb'
        # in pod config yaml
        env:
        - name: SECRET_USERNAME
            valueFrom:
                secretKeyRef:
                    name: test-secret
                    key: username
        # or in pod config
        envFrom:
        - secretRef:
            name: test-secret
        # run this in shell inside the container
        kubectl exec -i -t envfrom-secret -- /bin/sh -c 'echo "username: $username\npassword: $password\n"'

* kubernetes.io/dockerconfigjson：used to save docker registry authorization information

        kubectl create secret docker-registry atpdocker-credentials --docker-server=serverName --docker-username=User --docker-password=PW --docker-email=Email

* kubernetes.io/service-account-token：it is used in serviceaccount. this token is created automatically by kubernetes when serviceaccout is created. The token will also be mounted to /run/secrets/kubernetes.io/serviceaccount when Pod is using this serviceaccount.
### service
define accesss API for user, so that backend container is isolated from user

    apiVersion: v1
    kind: Service
    metadata:
        name: myservice
    spec:
        selector:
            app: myapp
        ports:
        - protocol: TCP
            port: 80
            targetPort: 8080
            name: myapp-http

### service account
service account is used for process in pod to call kubernetes api and other external service. service account is only valid in its own namespace. Every namespace will create a default service account automatically, token controller will create secret for service account

### Site Reliability Layers

#### Monitoring Layer / Metrics Server
monitoring running state of k8s
#### Scaling Layer / HPA
scaling the instances of your application up or down
#### Service Rules Layer
automate when / how your application should restart

## other kubernetes
### Rancher Labs (k3s)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201115234811.png)
rancher labs is a highly optimized iniature version of Kubernetes for the edge. it doesn’t compromise the API conformance and functionality.    
it is a self-sufficient, encapsulated entity that runs almost all the components of a Kubernetes cluster, including the API server, scheduler, and controller
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201115235002.png)
#### k3d
a program that run k3s in docker. there is also a vs code plugin available: https://github.com/inercia/vscode-k3d

##### Installation
https://k3d.io/#installation

##### usage

    #create a cluster
    k3d cluster create  
    k3d cluster create mycluster --api-port 127.0.0.1:6445 --servers 3 --agents 2 --volume '/home/me/mycode:/code@agent[*]' --port '8080:80@loadbalancer'
    k3d cluster create --config /home/me/myk3dcluster.yaml
    #check nodes
    kubectl get nodes
    #check creations
    k3d cluster|node|registry list


### k0s
K0s packages a single binary for both amd64 and arm64 architectures. It does not require any host OS dependencies besides the kernel. the "zero" in k0s distribution as the company's aspiration to provide a Kubernetes distribution with zero friction, zero dependencies, zero overhead, zero cost, and zero downtime

    $ #Download, install, and start a k0s server
    $ curl -sSfL k0s.sh | sh
    $ k0s server$ #Create and add a worker node
    $ k0s token create --role=worker
    $ k0s worker <TOKEN>$ #Or quickly try it out in a Docker container anywhere
    $ docker run -d --hostname controller --privileged -v /var/lib/k0s -p 6443:6443 k0sproject/k0s

### Engine Yard Kontainers and Hitachi Kubernetes Service (HKS)



## tools for kubernetes 
### Pinniped
cluster identity plugin for kubernetes
### Carvel
a set of tools for app deployment on cluster
* ytt
using comments against YAML structures; customize imperatively using conditionals and loops in a python-like language called Starlark;  overlay features allows the copy of the third-party config file to remain pristine and unmodified
* kbld
kbld looks for images within your config file, builds the images via Docker and pushes it to the registry of your choice
* kapp
CLI tool that calculates changes between your configuration and the live cluster state; and only applies the changes you approve
### kontena lens
smart dashboard for kubernetes
### monitoring
kube-prometheus(https://github.com/prometheus-operator/kube-prometheus) provides Grafana dashboard to monitor cluster health, z.B. Kubernetes API Servers and etcd.
we can use Prometheus to collect time-series metrics and Grafana for graphs, dashboards, and alerts.

### logging tools
scalable tools that can collect data from all the services and provide the engineers with a unified view of performance, errors, logs, and availability of components.
#### EFK Stack

    #installation
    helm install efk-stack stable/elastic-stack --set logstash.enabled=false --set fluentd.enabled=true --set fluentd-elasticsearch.enabled=true

#### PLG Stack (Promtail, Loki and Grafana)
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201226214501.png)
Loki is designed in a way that it can be used as a single monolith or can be used as microservice.  
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20201226214616.png)
* Elasticsearch uses Query DSL and Lucene query language which provides full-text search capability.Loki uses LogQL which is inspired my PromQL (Prometheus query language). It uses log labels for filtering and selecting the log data
* Both ELK and PLG are horizontally scalable but Loki has more advantages because of its decoupled read and write path and use of microservices-based architecture
* compared with ELK Loki is an extremely cost-effective solution because of the design decision to avoid indexing the actual log data. Only metadata is indexed and thus it saves on the storage and memory (cache).
    #installation
    $ helm repo add loki https://grafana.github.io/loki/charts
    $ helm repo update
    $ helm upgrade --install loki loki/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

#### Stackdriver