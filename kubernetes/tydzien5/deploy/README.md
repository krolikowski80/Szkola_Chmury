# [Deployment czyli jak połączyć całą wiedzę, którą zdobyłeś do tego miejsca.](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/deployment-czyli-jak-polaczyc-cala-wiedze-ktora-zdobyles-do-tego-miejsca/)

### [Ćwiczenia z  qwiklabs.com](https://www.qwiklabs.com/focuses/639?parent=catalog)

```bash
#Tworzę deployment
kubectl apply -f deployment.yaml

#Sprawdzam
kubectl get deploy

#Czy nmam Replica set
kubectl get rs

#Skalowanie deployment
kubectl scale deployments deployment --replicas=4

#Skalowanie RS (Niewykonalne, deployment jest ważniejszy)
kubectl scale rs deployment-595bdfc79f --replicas=2

kubectl get pod

    NAME                          READY   STATUS    RESTARTS   AGE
    deployment-595bdfc79f-89vzt   1/1     Running   0          9m20s
    deployment-595bdfc79f-98vtp   1/1     Running   0          9m20s
    deployment-595bdfc79f-dktwm   1/1     Running   0          17s
    deployment-595bdfc79f-hz2g8   1/1     Running   0          17s

    #Przegląd historii rollout
kubectl rollout history deployment --revision=1
```

## Przywracanie poprzedniej wersji
```bash
#Nowy deployment
kubectl apply -f ro1.yaml

#Przekierowanie portów
kubectl port-forward nginx-deployment-5d59d67564-cnthz 8080:80

#Pobieram nagłówki
curl -I -X GET http://localhost:8080

    HTTP/1.1 200 OK
    Server: nginx/1.7.9
    Date: Tue, 13 Oct 2020 19:41:35 GMT
    Content-Type: text/html
    Content-Length: 612
    Last-Modified: Tue, 23 Dec 2014 16:25:09 GMT
    Connection: keep-alive
    ETag: "54999765-264"
    Accept-Ranges: bytes

#Nowy obraz w deployment
kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1

#Status rollout
kubectl rollout status deployment.apps/nginx-deployment

#Pobieram nagłówki
curl -I -X GET http://localhost:8080

    HTTP/1.1 200 OK
    Server: nginx/1.9.1
    Date: Tue, 13 Oct 2020 19:51:39 GMT
    Content-Type: text/html
    Content-Length: 612
    Last-Modified: Tue, 26 May 2015 15:02:09 GMT
    Connection: keep-alive
    ETag: "55648af1-264"
    Accept-Ranges: bytes


#Łatwiejszy - deklaratywny sposób na rollout
#Zmiany zostały wprowadzone w pliku ro2.yaml
kubectl apply -f ro2.yaml 

#Status rollout
kubectl rollout status deployment.v1.apps/nginx-deployment
>> deployment "nginx-deployment" successfully rolled out

#Historia zmian
kubectl rollout history deployment nginx-deployment

#Historia zmian konkretnej revizji
kubectl rollout history deployment nginx-deployment --revision=2

#Przywracanie zmian - 1 do tyłu
kubectl rollout undo deployment nginx-deployment

#Przywracanie zmian do konkretnej wersji
kubectl rollout undo deployment nginx-deployment --to-revision=1
```