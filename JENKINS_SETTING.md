# jenkins kubernetes plugin setting

jenkins system setting > cloud > kubernetes

~~~sh

# Get kubernetes endpoint(kubernetes master API)
$ kubectl get ep
NAME         ENDPOINTS             AGE
kubernetes   xxx.xxx.xxx.xxx:443   3h

# Get GKE basic auth password
$ gcloud container clusters describe jenkins-cluster | grep pass 
$ gcloud container clusters describe jenkins-cluster | grep admin

~~~

