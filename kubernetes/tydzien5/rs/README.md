# [Jak działa i co daje Replica Set](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/jak-dziala-i-co-daje-replica-set/)
## [How a ReplicaSet works](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

```bash
#Tworzępody na podstawie pliku
kubectl create -f replicaset.yaml

#Sprawdzam
kubectl get rs

#jakie mamy pody
kubectl get pod -w

#kasuję jeden pod
kubectl delete pod frontend-nt5pk

```