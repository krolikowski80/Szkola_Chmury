# Instrukcja dla pracy domowej
## Tydzień 5

#### Opis

W tym tygodniu poznałeś  pierwsze - podstawowe - obiekty w Kubernetes.
Teraz przyszedł czas wykonać kilka ćwiczeń, które utrwalą Twoją wiedzę.
Zadań będzie więcej niż w poprzednich lekcjach. 

Powodzenia!

#### Udostępnienie pracy domowej

Na zakończenie każdej lekcji masz 'Wynik', który  proszę skopiuj do dokumentu tekstowego  lub zrób PrtScr i udostępnij w naszej grupie na Facebook.

#### Wymagania wstępne

- klaster Kuberenetes (AKS, AWS, GKE lub Minikube)
- kubectl z ustawionym połączeniem do Kubernetesa

#### Przygotowanie środowiska pracy

1. Najpierw utwórz **Namespace**, w którym będziesz wykonywać wszystkie ćwiczenia:

    ``
    kubectl create namespace homework5
    ``

2. Zmień aktualny **Context** dla kubectl na ten nowo utworzony:

    `` kubectl config set-context --current --namespace=homework5``

