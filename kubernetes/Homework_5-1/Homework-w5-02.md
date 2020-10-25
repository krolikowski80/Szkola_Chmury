# Deployment

#### Twoim zadaniem będzie stworzenie Deployment i wykonanie kilku operacji.

## Zadanie 1. Stworzenie Deployment.

1. Stwórz nowy plik:  
`my_deployment_definition.yaml`
2. Umieść w nim zawartość jak poniżej:  
````apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      env: prod
  template:
    metadata:
      labels:
        env: prod
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
````  
(Zwróć uwagę na zawartość `selector >> matchLabels` oraz `template >> metadata >> labels`)  
3. Zapisz zmiany i wywołaj polecenie:  
`kubectl apply -f my_deployment_definition.yaml`  
4. Wpisz w linii poleceń:  
`kubectl get pods -l=env=prod`  
5. Zauważ, że Twoje środowisko posiada teraz 3 pody z tym selectorem.  
6. Usuń wszystkie pody z selectorem `env: prod`:  
`kubectl delete pods -l=env=prod`  
7. Ponownie sprawdź zawartość Twojego środowiska PROD:    
`kubectl get pods -l=env=prod`

## Zadanie 2: Praca z Deployment

Deployment zarządza obiektem ReplicaSet. Sprawdź Labele, ktorych używa.

1. Polecenie: 

``
kubectl get deployments nginx-deployment -o jsonpath='{.spec.selector.matchLabels}'
``

Deployment zarządza ReplicaSet z labelem `env=prod`. Znajdź obiekt:  
 ``kubectl get replicasets --selector=env=prod``

Jak widzisz masz 2 repliki obiektu zarządzanego przez Deployment >> ReplicaSet.  

1. Wykonaj skalowanie:  
``kubectl scale deployments nginx-deployment --replicas=4``
3. Sprawdź aktualną liczbę POD:   
``kubectl get replicasets --selector=env=prod``

4. Spróbujmy teraz przeskalować obiekt ReplicaSet. 
(`kubectl get replicasets --selector=env=prod`)  
Wywołaj polecenie:  
``
kubectl scale replicasets <-REPLICASET-NAME-> --replicas=1
``  
(Zamień nazwę wyświetloną wcześniejszym poleceniem w `<-REPLICASET-NAME->`)
5. Ponownie sprawdż ilość obiektów Twojej Repliki:  
 ``kubectl get replicasets --selector=env=prod``

Powinieneś wiedzieć co się właśnie stało (dlaczego nadal są 4 repliki).

>Pamiętaj, Kubernetes jest systemem o hierarchicznych obiektach i samo-uzdrawiającym się. Nie ma znaczenia, że modyfikujesz obiekt ReplicaSet, bo jest on zarządzany przez Deployment. Zawsze musisz modyfikować obiekt najwyższy lub zarządzający. Twoje zmiany będą nadpisywane w innym przypadku przez Kubernetesa.

## Wynik

Wynik wywołania polecenia:  
`kubectl get pods -l=env=prod`