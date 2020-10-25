# Service

## Zadanie 1. Stworzenie Service i dostęp do niego.

1. Stwórz serwis za pomocą polecenia:  
`kubectl expose deployment nginx-deployment`  

2. Wyświetl serwisy:  
`kubectl get service`
(Zwróć uwagę na `EXTERNAL-IP <None>`. Oznacza to, że nadal nie możesz z zewnatrz połączyć się do swoich POD. Ustanowiony został jedynie CLUSTER-IP, do komunikacji wewnętrznej w klastrze.)  

3. Sprawdź definicję Twojego Service w klastrze:   
`kubectl describe svc nginx-deployment`  
(Znowu zwróć uwagę na `selector` oraz `endpoints`. )

4. Sprawdź czy na Twoim klastrze działa usluga DNS:  
`kubectl get services kube-dns --namespace=kube-system`

5. Uruchom POD i kontener, z którego będziesz mógł się połączyć z serwisem:  
`kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm`  
(Zostaniesz do niego połączony w trybie interaktywnym)  

6. Wywołaj polecenie:  
`nslookup nginx-deployment`  

7. Odnajdź `Name:      nginx-deployment` i w linii poniżej skopiuj do schowka nazwę DNS (np. nginx-deployment.default.svc.cluster.local)

8. Wywołaj `CURL` dla skopiowanej nazwy DNS:  
`curl <DNS name>`

10. Powinieneś zobaczyć HTML startowej strony Nginx.:

```` 
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
....
````

11.  Gratulacje! Udało Ci się nawiązać połączenie z jednym z POD utworzonych za pomocą Deployment, używajac przy tym Service typu ClusterIP i DNS.  
Zamknij konsolę:  
`exit`


## Wynik

Wynik wywołania polecenia:  
`kubectl get service`