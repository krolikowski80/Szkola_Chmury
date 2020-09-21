# [Zadanie nr 4 - Klaster kubernetes](https://szkolachmury.pl/kubernetes/tydzien-4-klaster-kubernetes/praca-domowa-nr-4/)

> Zainstaluj proszę na swoim komputerze (lub tam gdzie robisz laby) jedno z dwóch rozwiązań:
>
> - minikube (https://kubernetes.io/docs/tasks/tools/install-minikube/)
> - K8s, który jest dostępny w ramach środowiska Docker (https://www.docker.com/blog/docker-windows-desktop-now-kubernetes/)
> - Sprawdź proszę zachowanie tych klastrów za pomocą poleceń kubectl cluser-info, kubectl get pods --all-namespaces, kubectl get nodes.

# 1. Uruchomienie Minikube
```bash
# 1.1 Sprawdzenie statusu
[20:08][tomasz@lapek][~/my_repos/Szkola_Chmury] $ minikube status
minikube
type: Control Plane
host: Stopped
kubelet: Stopped
apiserver: Stopped
kubeconfig: Stopped

#1.2 Uruchomienie
[20:18][tomasz@lapek][~/my_repos/Szkola_Chmury] $ minikube start
😄  minikube v1.13.0 on Ubuntu 20.04
✨  Using the kvm2 driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
🔄  Restarting existing kvm2 VM for "minikube" ...
🎉  minikube 1.13.1 is available! Download it: https://github.com/kubernetes/minikube/releases/tag/v1.13.1
💡  To disable this notice, run: 'minikube config set WantUpdateNotification false'

🐳  Preparing Kubernetes v1.19.0 on Docker 19.03.12 ...
🔎  Verifying Kubernetes components...
🔎  Verifying ingress addon...
🌟  Enabled addons: dashboard, default-storageclass, helm-tiller, ingress, ingress-dns, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" by default

#1.3 Sprawdzanie informacj o klastrze
[20:19][tomasz@lapek][~/my_repos/Szkola_Chmury] $ kubectl cluster-info 
Kubernetes master is running at https://192.168.39.102:8443
KubeDNS is running at https://192.168.39.102:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy


[20:23][tomasz@lapek][~/my_repos/Szkola_Chmury] $ kubectl get pods --all-namespaces
NAMESPACE              NAME                                        READY   STATUS             RESTARTS   AGE
default                hello                                       0/1     CrashLoopBackOff   21         6d21h
kube-system            coredns-f9fd979d6-58vfx                     1/1     Running            4          6d21h
kube-system            etcd-minikube                               1/1     Running            4          6d21h
kube-system            ingress-nginx-admission-create-8vfc2        0/1     Completed          0          6d21h
kube-system            ingress-nginx-admission-patch-vxdn4         0/1     Completed          2          6d21h
kube-system            ingress-nginx-controller-789d9c4dc-kx499    1/1     Running            5          6d21h
kube-system            kube-apiserver-minikube                     1/1     Running            4          6d21h
kube-system            kube-controller-manager-minikube            1/1     Running            4          6d21h
kube-system            kube-ingress-dns-minikube                   1/1     Running            0          5d
kube-system            kube-proxy-6smpw                            1/1     Running            4          6d21h
kube-system            kube-scheduler-minikube                     1/1     Running            4          6d21h
kube-system            storage-provisioner                         1/1     Running            6          6d21h
kube-system            tiller-deploy-54d64977cc-r47tq              1/1     Running            1          5d
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-ccf4v   1/1     Running            2          5d22h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-fv7sf   0/1     NodeAffinity       0          5d22h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-ljl2m   0/1     NodeAffinity       0          5d22h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-lkn7w   0/1     NodeAffinity       0          6d21h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-m7sl9   0/1     NodeAffinity       0          5d22h
kubernetes-dashboard   kubernetes-dashboard-5c448bc4bf-8k2vq       1/1     Running            3          5d22h
kubernetes-dashboard   kubernetes-dashboard-5c448bc4bf-9fgrj       0/1     NodeAffinity       0          5d22h
kubernetes-dashboard   kubernetes-dashboard-5c448bc4bf-g9xg2       0/1     NodeAffinity       0          5d22h
kubernetes-dashboard   kubernetes-dashboard-5c448bc4bf-jgm5r       0/1     NodeAffinity       0          6d21h
kubernetes-dashboard   kubernetes-dashboard-5c448bc4bf-rb4sd       0/1     NodeAffinity       0          5d22h


[20:23][tomasz@lapek][~/my_repos/Szkola_Chmury] $ kubectl get nodes
NAME       STATUS   ROLES    AGE     VERSION
minikube   Ready    master   6d21h   v1.19.0

#1.4 Zatrzymanie minikube
[20:24][tomasz@lapek][~/my_repos/Szkola_Chmury] $ minikube stop
✋  Stopping node "minikube"  ...
🛑  1 nodes stopped.
```


>Wybierz ulubionego dostawcę chmurowego pomiędzy GCP , AWS  oraz Azure  i w wybranym z nich postaw swój pierwszy klaster Kubernetes bazując na wiedzy zdobytej w tych lekcjach. Może być to na początek mały, jednonodowy klaster, z czasem będziemy zmieniać jego konfigurację.

# 2. Uruchamianie kontenera Node.js w Google Kubernetes Engine
### 2.1 Tworzenie klastra
```bash
#Zmienne 
clusterName="zadanie4-tk-cluster"

#Tworzenie klastra
gcloud container clusters create $clusterName

#Uwierzytelnianie się do klastra
gcloud container clusters get-credentials $clusterName

#Jaki kontekst ma środowisko
kubectl config current-context

gke_szkola-chmury-tk_europe-west1-b_zadanie4-tk-cluster

#Jakie nody mamy powiązane?
kubectl get nodes -o wide

NAME                                                 STATUS   ROLES    AGE    VERSION           INTERNAL-IP   EXTERNAL-IP      OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-zadanie4-tk-cluster-default-pool-558e3f6d-1hsx   Ready    <none>   2m5s   v1.15.12-gke.20   10.132.0.30   35.205.25.79     Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-zadanie4-tk-cluster-default-pool-558e3f6d-5rgp   Ready    <none>   2m5s   v1.15.12-gke.20   10.132.0.29   35.195.128.146   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-zadanie4-tk-cluster-default-pool-558e3f6d-5wsk   Ready    <none>   2m5s   v1.15.12-gke.20   10.132.0.31   35.233.81.37     Container-Optimized OS from Google   4.19.112+        docker://19.3.1


#Konfiguracja kubectl
kubectl cluster-info

Kubernetes master is running at https://34.76.141.236
GLBCDefaultBackend is running at https://34.76.141.236/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
Heapster is running at https://34.76.141.236/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://34.76.141.236/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://34.76.141.236/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
### 2.2 Tworzenie i publikowanie aplikacji Node.js
```bash
#Zmienne
projectID="szkola-chmury-tk"

#Pobierz przykładowy kod
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git

#Zmiana katalogu
cd nodejs-docs-samples/containerengine/hello-world/

#Budowa Dockerfile
cat Dockerfile

# [START all]
FROM node:6-alpine
EXPOSE 8080
COPY server.js .
CMD node server.js
# [END all]

#Budowanie kontenera
docker build -t gcr.io/$projectID/hello-node:1.0 .

#Lista obrazów
docker images 

REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
gcr.io/szkola-chmury-tk/hello-node   1.0                 d8246395f435        13 seconds ago      56.1MB


#Publikowanie kontenera
gcloud docker -- push gcr.io/$projectID/hello-node:1.0

#Wdrażanie aplikacji Node.js
kubectl create deployment hello-node --image=gcr.io/$projectID/hello-node:1.0

#Podgląd wdrożenia
kubectl get deployments

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           78s

#Jakie mam pody
kubectl get pods

NAME                          READY   STATUS    RESTARTS   AGE
hello-node-547d8757b4-mr2zb   1/1     Running   0          2m8s

#Zezwalaj na ruch zewnętrzny
kubectl expose deployment hello-node \
--name=hello-node \
--type=LoadBalancer \
--port=80 \
--target-port=8080

service/hello-node exposed

#Adres IP dla swojej usługi
kubectl get svc hello-node

NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
hello-node   LoadBalancer   10.3.242.220   34.78.7.132   80:30727/TCP   78s

#Sprawdź wdrożenie
curl 34.78.7.132
Hello Kubernetes!
```

# 2.3 Usuwanie zasobów
```bash
rm -rf nodejs-docs-samples/

gcloud container clusters delete $clusterName

gcloud docker -- rm gcr.io/$projectID/hello-node

docker rm $(docker ps -aq)

docker rmi -f $(docker images -q)
```