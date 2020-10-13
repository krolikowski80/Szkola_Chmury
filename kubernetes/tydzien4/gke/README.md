## [GKE Architektura](https://szkolachmury.pl/kubernetes/tydzien-4-klaster-kubernetes/gke-architektura/)

### LNKI

* [Regional Clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters)

* [Alpha Cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/alpha-clusters)

* [Vertical PODs Autoscaler](https://cloud.google.com/kubernetes-engine/docs/concepts/verticalpodautoscaler)

* [Cluster Autoscaler](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler)

* [Sandbox PODs](https://cloud.google.com/kubernetes-engine/docs/how-to/sandbox-pods)

* [Security w GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview)

### [Ćwiczenia](https://google.qwiklabs.com/focuses/878?parent=catalog&qlcampaign=77-18-gcpd-236&utm_source=gcp&utm_campaign=kubernetes&utm_medium=documentation)
```bash
#Tworzenie klastra Kubernetes Engine
gcloud container clusters create [CLUSTER-NAME]

#Uwierzytelnianie się do klastra
gcloud container clusters get-credentials [CLUSTER-NAME]

#Utwórz nowe wdrożenie - hello-server
kubectl create deployment hello-server --image=gcr.io/google-sample/hello-app:1.0

#Wystawienie aplikacji na ruch zewnętrzny
kubectl expose deployment hello-server --type=LoadBalancer --port 8080

#Sprawdź usługę
kubectl get service

http://[EXTERNAL-IP]:8080

#Usuwanie zasobów
gcloud container clusters delete [CLUSTER-NAME]
```