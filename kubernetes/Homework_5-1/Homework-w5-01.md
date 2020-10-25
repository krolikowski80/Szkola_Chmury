# POD

#### Twoim zadaniem będzie stworzenie POD i wykonanie kilku operacji.

## Zadanie 1. Stworzenie POD.

1. Uruchomienie POD z kontenerem NGINX:  
``kubectl run my-nginx-prod --restart=Never --image=nginx:1.7.9``

1. Zweryfikuj czy POD działa.  
``kubectl get pods``
 

## Zadanie 2. Podgląd szczegółów i edycja.

1. Wpisz:  
``kubectl describe pods my-nginx-prod``  
(Przeanalizuj zwrócony opis Twojego POD)


2. Wykonaj eksport definicji do pliku za pomocą:  
``kubectl get pod my-nginx-prod --export -o yaml > my_pod_definition.yaml``
3. Otwórz plik **my_pod_definition.yaml** w dowolnym edytorze i przenalizuj jego zawartość.
4. Następnie zastąp linie:  
``- image: nginx:1.7.9`` --> ``- image: nginx:1.9.1``  
5. Nie zamykaj jeszcze pliku, wykonaj jeszcze jedną zmianę.
Dodaj nowy `Label` do POD.  
Pomiedzy linią 6/7 wstaw:  
    ``env: prod``  
    (Zwróć uwagę, aby `env` było na tym samym poziomie co `run`)
6. Wykonaj aktualizację swojego POD za pomocą:  
``kubectl apply -f my_pod_definition.yaml`` 
7. Ponownie sprawdź definicję dla Twojego POD:  
``kubectl describe pod my-nginx-prod``  
(Zwróć szczególnie uwagę na to, czy POD używa nowszej wersji Nginx oraz na zawartość Events)

## Zadanie 3. Połączenie do Nginx.

1. Utwórz połączenie (proxy) do Twojego POD:  
``kubectl port-forward my-nginx-prod 8080:80``  
2. Otwórz przeglądarkę i adres:  
 ``http://localhost:8080``  
(Powinieneś zobaczyć 'ekran startowy' Nginx).

## Zadanie 4. Stworzenie drugiego POD dla TEST.

1. Otwórz plik **my_pod_definition.yaml** ponownie.
2. Następnie zastąp linie:  
``env: prod`` --> ``env: test``  
oraz  
``name: my-nginx-prod`` --> ``name: my-nginx-test``   
(W zagnieżdżeniu: `metadata`)  
Zapisz zmiany.

3.  Wykonaj polecenie stworzenia nowego POD:   
``kubectl apply -f my_pod_definition.yaml``

8. Zweryfikuj stan swojego środowiska.  
``kubectl get pods``  
(powinieneś widzieć dwa POD: `my-nginx-prod` oraz `my-nginx-test`)

## Zadanie 5. Analiza logów i logowanie do kontenera wewnątrz POD.

1. Wpisz:   
``kubectl logs my-nginx-prod``  
(Powinieneś widzieć log z Nginx, ktory został wygenerowany po otwarciu tej instancji w przeglądarce.)

2. Zaloguj się do kontenera w POD:  
``kubectl exec -it my-nginx-prod /bin/bash``  
(Możesz wykonać kilka poleceń jak: `env` i `ls`)  
Wyjdź z konsoli za pomocą polecenia: `exit`

3. Na zakończenie wyświetl tylko POD-y, które mają label `env: prod` za pomocą polecenia:  
``kubectl get pods -l=env=prod``

## Wynik

Wynik wywołania polecenia:  
`kubectl get pods -l=env=prod`

