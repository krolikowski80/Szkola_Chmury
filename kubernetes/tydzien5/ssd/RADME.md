# [Stateful Set & DemonSet](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/stateful-set-demonset/)


```bash
#DeamonSety z wszystkich namespace
kubectl get ds --all-namespaces

#Odpalam Deamon Seta na nodach
kubectl apply -f ds.yaml

#Więcej info i DS
kubeclt describe ds daemonset

#Usuwam DS
kubectl delete ds daemonset

#Lista podów z nodami na których są uruchomione
kubectl get pods -o wide

#Label dla noda
kubectl label nodes <-YOUR-NODE-NAME-> ds=tru
```

# [StatefulSet](https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/)

```bash
#Podglądam tworzenie podów
kubectl get pods -w

#Tworzę pody
kubectl apply -f statefulset.yaml

#Sprawdzam hostname
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done 

#Odpalam busybox
kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm

#Usuwam poda
kubectl delete pod -l app=nginx
```