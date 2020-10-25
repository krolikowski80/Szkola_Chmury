# [Czym jest Service](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/czym-jest-service-i-dlaczego-musisz-go-poznac/)

```bash
#Tworzę deployment
kubectl apply -f depl.yaml

#Tworze service
kubectl apply -f service.yaml

#Sprawdzam czy service działa
kubectl get svc

#Impratywne tworzenie serwice (prościej, na chwilę)
kubectl expose deployment my-nginx

#Sprawdzam swój service
kubectl get service my-nginx-service

#Używam busyboxa do testów
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm
nslookup my-nginx
curl my-nginx.default.svc.cluster.local 
```