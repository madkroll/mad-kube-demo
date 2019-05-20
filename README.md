# mad-kube-demo
Demo setup for k8s and docker

## build project
Run command to build a project and related containers:
'mvn clean package'

## import containers to minikube
Minikube uses it's own docker daemon. So before using containers in minikube - first import them by command:
'docker save _image_id_ | (eval $(minikube docker-env) && docker load)'

Alternatively one may build containers directly in minikube docker

## contains
- installation and setup (docker, kubernetes, minikube, CI)
- stateless service
- distributed in-memory cache service
- scheduled cron job
- ingress service
    - http rule
