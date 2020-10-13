# [Czym są i jak działają Namespaces?](https://szkolachmury.pl/kubernetes/tydzien-5-bazowe-obiekty-w-kubernetes/czym-sa-i-jak-dzialaja-namespaces/)
```bash
#Wyświetl listę podów
kubectl get pods

#Wyświetl wszystkie pody we wszystkich przestrzeniach nazw
kubectl get pods --all-namespaces

#Wyświetla listę podów w podanej przestrzeni nazw
kubectl get pods -n szkola-chmury

# Wszystkie zasoby w przestrzeni nazw
kubectl api-resources --namespaced=true

# Wszystkie zasoby bez przestrzeni nazw
kubectl api-resources --namespaced=false

# utwórz zasoby na podstawie pliku namespace.yaml
kubectl apply -f namespace.yaml

#Wjakiesj przestrzeni nazw pracujemy
kubectl config view | grep namespace

#Ustaw przestrzeń nazw na podaną
kubectl config set-context --current --namespace=szkola-chmury

#Tworzy poda w danej przestrzenie nazw na podstawie pliku pod.yaml
kubectl apply -f pod.yaml -n szkola-chmury

```
