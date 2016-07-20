# What's this?

Create jenkins cluster on kubernetes(GKE).

# Deployment to GKE

* Build jekins images 
* Push google container registry(gcr)
* Create GCP disk for jenkins perpetuation disk.
* Create GKE cluster
* Create kubernetes resources
  * namespace
  * secret
  * deployment
  * service

## Build jekins images 

If you needed add preinstall plugins and jenkins's customized initialize process.

Edit `plugins.txt` and `custom.groovy` files. 

~~~sh
# Build master image
$ cd dockerfiles
$ docker build -t grc.io/${GCP_PROJECT}/jenkins . 

~~~

## Build jekins slave images(with ruby)

~~~sh
$ cd dockerfiles

$ build-ruby-slave.sh       # build 2.3.1 container tag:jenkins-slave-ruby:2.3.1
$ build-ruby-slave.sh 2.3.0 # build 2.3.0 container tag:jenkins-slave-ruby:2.3.0

~~~

# Push google container registry(gcr)

~~~sh
$ gcloud docker push gcr.io/${GCP_PROJECT}/jenkins
$ gcloud docker push gcr.io/${GCP_PROJECT}/jenkins-slave-ruby:2.3.1
~~~

# Create GCP disk for jenkins perpetuation disk.

~~~sh
gcloud compute disks create jenkins-home --zone ${ZONE}
~~~

# Create GKE Cluster

### CAUTION CAUTION CAUTION
`CAUTION: Cluster GCP scope can not be changed later.`
### CAUTION CAUTION CAUTION

Recommend create GUI.
Using the CLI If you needed.

~~~sh
gcloud container clusters create "jenkins-cluster" \
  --num-nodes 3  \
  --zone ${ZONE} \ # e.g. "asia-east1-c"
  --machine-type "YOUR_MACHINE" \ # e.g. "n1-highcpu-4"
  --scope "compute-rw","storage-rw","bigquery","logging-write","monitoring"
~~~

# Create kubernetes resources

This section is premise current directory is k8s.
`cd k8s`

## namespace

~~~sh
$ kubectl create namespace jenkins
$ kubectl get ns --namespace jenkins
~~~

## secret
~~~sh
# file name == secret index key
$ echo -n "YOUR_SECRET" > google-app-secret
$ kubectl create secret generic jenkins --from-file=google-app-secret --namespace jenkins
$ kubectl get secret --namespace jenkins
~~~

## deployment

Edit your gcp client id and secret.

~~~sh
# edit jenkins-deploy.yml
$ kubectl create -f jenkins-deploy.yml
$ kubectl get deployment --namespace jenkins
$ kubectl get pod --namespace jenkins
~~~

## service

~~~sh
$ kubectl create -f jenkins-service.yml

# Wait a min. After that check your gcp project Loadbalancer.
# Perhaps you should TCP loadbalancer has been created.
$ kubectl get svc --namespace jenkins
~~~

# reference

* recommend repository.

https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes

* GKE official guide
https://cloud.google.com/solutions/configuring-jenkins-container-engine

https://www.youtube.com/watch?v=PFCSSiT-UUQ&index=21&list=PL69nYSiGNLP0Ljwa9J98xUd6UlM604Y-l

http://www.slideshare.net/devopsdaysaustin/continuously-delivering-microservices-in-kubernetes-using-jenkins
* gcePersistentDisk permission:

http://stackoverflow.com/questions/35213589/docker-container-with-non-root-user-deployed-in-google-container-engine-can-not
