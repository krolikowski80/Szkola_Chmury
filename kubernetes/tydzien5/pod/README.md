# [POD](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/pod/)

* [POD](https://kubernetes.io/docs/concepts/workloads/pods/pod/)

* [Labels & Selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)

```bash
# Apply
kubectl apply -f pod.yaml

#Zabawa z Labels
kubectl get pods --show-labels
kubectl get pod -l env=dev --show-labels
kubectl delete pod -l env=dev

```