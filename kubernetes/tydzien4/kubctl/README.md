## [Praca z kubectl](https://szkolachmury.pl/kubernetes/tydzien-4-klaster-kubernetes/praca-z-kubectl/)

### LNKI

* [Cheat Scheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

* [Kubectl Book](https://kubectl.docs.kubernetes.io/)

* [Kubectl install on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)

* [Kubectl install on Mac](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)

* [Kubectl install on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows)

* [Minikube – instalacja](https://kubernetes.io/docs/setup/learning-environment/minikube/#installation)

* [Instalacja minikube z KVM na Ubuntu](https://computingforgeeks.com/how-to-run-minikube-on-kvm/#ex1)

* [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)

### Pierwszy klaster

```bash
#Startuję środowisko
minikube start

#Jaki kontekst ma środowisko
kubectl config current-context

#Jakie nody mamy powiązane?
kubectl get nodes -o wide

#Konfiguracja kubectl
kubectl cluster-info

#PIERWSZY POD W ŚRODOWISKU
kubectl run hello --image=hello-world

#Jakie mam pody
kubectl get pods

#Czytam logi z kontenera
kubectl logs hello

#Dokładne informacje o klastrze
kubectl describe node/minikube | more

#Przęłączanie pomiędzy klastrami
kubectl config set-context [NAME]
```