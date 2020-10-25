# [Zadaniee nr 5](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/praca-domowa-nr-5/)
# Zadanie 5.1 - BAZOWE OBIEKTY W KUBERNETES


#### Wymagania wstępne

- klaster Kuberenetes w GKE
- kubectl z ustawionym połączeniem do Kubernetesa

```bash
#Zmienne
echo $'\n#Podstawowe\nexport clusterName=zad5tk\nexport nameSpace=homework5' >>.zad5_env  && source .zad5_env

#Tworzę klaster na GCP
gcloud container clusters create $clusterName

#Uzyskuję uwierzytelnienie dla klastra
gcloud container clusters get-credentials $clusterName

#Tworzę NameSpace
kubectl create namespace $nameSpace

#Zmienim Context dla kubectl na ten nowo utworzony:
kubectl config set-context --current --namespace=$nameSpace
```
## Zadanie 5.1.1 Stworzenie POD.
```bash
#Zmienne
echo $'\n#Dla POD\nexport pod_name=my-nginx-prod' >>.zad5_env  && source .zad5_env

#Uruchomienie POD z kontenerem NGINX:  
kubectl run $pod_name --restart=Never --image=nginx:1.7.9

#Zweryfikuj czy POD działa.  
kubectl get pods
    NAME            READY   STATUS    RESTARTS   AGE
    my-nginx-prod   1/1     Running   1          34s

```
## Zadanie 5.1.2 Podgląd szczegółów i edycja.
```bash
#Eksport definicji do pliku
kubectl get pod my-nginx-prod -o yaml > my_pod_definition.yaml

#aktualizacja POD  
kubectl apply -f my_pod_definition.yaml

#ponownie sprawdzam definicję dla POD:  
kubectl describe pod my-nginx-prod
    Image:          nginx:1.9.1
    
    ........

    Events:
      Type    Reason     Age                  From               Message
      ----    ------     ----                 ----               -------
      Normal  Scheduled  5m16s                default-scheduler  Successfully assigned homework5/my-nginx-prod to   gke-zad5tk-default-pool-899742c8-fkdh
      Normal  Pulled     5m15s                kubelet            Container image "nginx:1.7.9" already present on machine
      Normal  Created    38s (x2 over 5m15s)  kubelet            Created container my-nginx-prod
      Normal  Started    38s (x2 over 5m15s)  kubelet            Started container my-nginx-prod
      Normal  Killing    38s                  kubelet            Container my-nginx-prod definition changed, will be restarted
      Normal  Pulled     38s                  kubelet            Container image "nginx:1.9.1" already present on machine
```

## Zadanie 5.1.3 Połączenie do Nginx.
```bash
#połączenie (proxy) do POD:  
kubectl port-forward $pod_name 8080:80

#W przeeglądarce
http://localhost:8080
#i jest 'ekran startowy' Nginx
```
# Zadanie 5.1.4 Stworzenie drugiego POD dla TEST.
```bash
#Zmienne
echo $'\nexport pod_name_test=my-nginx-test' >>.zad5_env  && source .zad5_env

#Zmiany w my_pod_definition.yaml
env: prod --> env: test  
#oraz  
name: my-nginx-prod --> name: my-nginx-test

#Stan środowisk
kubectl get pod
    NAME            READY   STATUS    RESTARTS   AGE
    my-nginx-prod   1/1     Running   1          20m
    my-nginx-test   1/1     Running   0          12s

```
## Zadanie 5.1.5 Analiza logów i logowanie do kontenera wewnątrz POD.
```bash
#Przegląd logów
kubectl logs $pod_name

#Logowanie się do kontenera w POD:  
kubectl exec -it $pod_name /bin/bash

kubectl exec -it $pod_name_test /bin/bash

#Wyświetl tylko POD-y, które mają label env: prod
kubectl get pods -l=env=prod
    NAME            READY   STATUS    RESTARTS   AGE
    my-nginx-prod   1/1     Running   1          35m    

#Wyświetl tylko POD-y, które mają label env: test
kubectl get pods -l=env=test
    NAME            READY   STATUS    RESTARTS   AGE
    my-nginx-test   1/1     Running   0          15m
```

# Zadanie 5.2 Deployment
## Zadanie 5.2.1 Stworzenie Deployment.

```
#Zmienne
echo $'\nexport my_deployment_name=nginx-deployment' >>.zad5_env  && source .zad5_env

#Tworzę nowy plik:  `my_deployment_definition.yaml`

#Odpalam deployment
kubectl apply -f my_deployment_definition.yaml

#Sprawdzam pody z labelsami = prod
kubectl get pods -l=env=prod

#Usuwam wszystkie pody z selectorem `env: prod`
kubectl delete pods -l=env=prod

#Ponownie sprawdzam zawartość środowiska PROD:    
kubectl get pods -l=env=prod
```

## Zadanie 5.2.2 Praca z Deployment
```bash
#Deployment zarządza obiektem ReplicaSet. Sprawdzam Labele, ktorych używa.
kubectl get deployments $my_deployment_name -o jsonpath='{.spec.selector.matchLabels}'

#Deployment zarządza ReplicaSet z labelem `env=prod`
kubectl get replicasets --selector=env=prod

#Skalowanie:  
kubectl scale deployments $my_deployment_name --replicas=4

#Sprawdź aktualną liczbę POD:   
kubectl get replicasets --selector=env=prod

#Teraz skaluję obiekt ReplicaSet. 
kubectl get replicasets --selector=env=prod

#Kubernetes jest systemem o hierarchicznych obiektach i samo-uzdrawiającym się. Nie ma znaczenia, że modyfikujesz obiekt ReplicaSet, bo jest on zarządzany przez Deployment. 
#Zawsze musisz modyfikować obiekt najwyższy lub zarządzający. Twoje zmiany będą nadpisywane w innym przypadku przez Kubernetesa.
kubectl get replicasets --selector=env=prod
    NAME                         DESIRED   CURRENT   READY   AGE
    nginx-deployment-94b68cc98   4         4         4       26m

#Wynik wywołania polecenia:  
kubectl get pods -l=env=prod
    NAME                               READY   STATUS    RESTARTS   AGE
    nginx-deployment-94b68cc98-ghwfb   1/1     Running   0          3m17s
    nginx-deployment-94b68cc98-k54xn   1/1     Running   0          3m17s
    nginx-deployment-94b68cc98-kkbw7   1/1     Running   0          25m
    nginx-deployment-94b68cc98-m457w   1/1     Running   0          3m17s
```

# Zadanie 5.3 Service

## Zadanie 5.3.1 Stworzenie Service i dostęp do niego.
```bash
#Stwórz serwis za pomocą polecenia:  
kubectl expose deployment $my_deployment_name

#Wyświetl serwisy
kubectl get services

#Sprawdzam definicję Service w klastrze
kubectl describe svc $my_deployment_name

#Sprawdź czy na klastrze działa usluga DNS:  
kubectl get services kube-dns --namespace=kube-system

#Uruchamiam POD i kontener, z którego będę mógł się połączyć z serwisem:  
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm

#Wywołaj polecenie:  
nslookup nginx-deployment

#Odnajdź `Name:      nginx-deployment` i w linii poniżej skopiuj do schowka nazwę DNS (np. nginx-deployment.default.svc.cluster.local)

#Wynik
kubectl get service
    NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    nginx-deployment   ClusterIP   10.23.241.219   <none>        80/TCP    20m
```

# Zadanie 5.4 StatefulSets

## Zadanie 5.4.1 Stworzenie StatefulSet
```bash
#Tworzę plik statefulset.yaml

#Tworzę StatefulSet
kubectl apply -f statefulset.yaml
```
## Zadanie 5.4.2
```bash
#Każdy POD ma swoją nazwę, którą możesz odczytać z poziomu samego POD-a.
kubectl exec web-0 -- sh -c 'hostname'
    web-0

kubectl exec web-1 -- sh -c 'hostname'
    web-1

#Uruchamiam POD i kontener, z którego będę mógł się połączyć z serwisem:  
kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm

#Sprwadź nazwy DNS dla naszych dwóch kontenerów:  
nslookup web-0.nginx
    Server:    10.23.240.10
    Address 1: 10.23.240.10 kube-dns.kube-system.svc.cluster.local

    Name:      web-0.nginx
    Address 1: 10.20.1.8 web-0.nginx.homework5.svc.cluster.local

nslookup web-1.nginx
    Server:    10.23.240.10
    Address 1: 10.23.240.10 kube-dns.kube-system.svc.cluster.local

    Name:      web-1.nginx
    Address 1: 10.20.0.15 web-1.nginx.homework5.svc.cluster.local

#Usuń POD-y
kubectl delete pod -l app=nginx

#Ponowne sprawdzenie
kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
nslookup web-0.nginx
    Server:    10.23.240.10
    Address 1: 10.23.240.10 kube-dns.kube-system.svc.cluster.local

    Name:      web-0.nginx
    Address 1: 10.20.2.11 web-0.nginx.homework5.svc.cluster.local

nslookup web-1.nginx
    Server:    10.23.240.10
    Address 1: 10.23.240.10 kube-dns.kube-system.svc.cluster.local

    Name:      web-1.nginx
    Address 1: 10.20.1.9 web-1.nginx.homework5.svc.cluster.local

#Usuwanie zasobów
kubectl delete namespace
```