 # [Zadanie nr 4](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/zadanie-domowe-nr-4/)

* [1. Zadanie 1](#1-zadanie-1)
    * [1.1 Przygotowanie `Cloud Storage`](#11-przygotowanie-cloud-storage)
    * [1.2 Przygotowanie `VM`](#12-Przygotowanie-VM)
    * [1.3 Logowanie i sprawdzenie uprawnień](#13-logpwanie-i-sprawdzenie-uprawnień)
    * [1.4 Wymiana `Service Account`](#14-wymiana-service-account)
    * [1.5 Kolejne sprawdzenie uprawnień](#15-kolejne-sprawdzenie-uprawnień)
    * [1.6 Dodawanie uprawnień odczytu do SA](#16-dodawanie-uprawnień-odczytu-do-sa)
*[2. Zadanie 2](#2-zadanie-2)
# 1. Zadanie 1

> Klient poprosił cię o przygotowanie maszyny dla swoich pracowników, którzy będą mogli pobierać faktury z przygotowanego repozytorium (w naszym przypadku jest to pojemnik Cloud Storage)


### 1.1 Przygotowanie `Cloud Storage`
```bash
#Zmienne
bucketName="zadanie4tk" #lokacja brana z configuracji projektu

#Tworzę bukiecik
gsutil mb gs://${bucketName}/

#Kopiuję pliki do bucket
gsutil cp ../sample_data/* gs://${bucketName}/

#Wynik
[16:19][tomasz@lapek][~/my_repos/Szkola_Chmury] $ gsutil ls gs://${bucketName}/
gs://zadanie4tk/file01.txt
gs://zadanie4tk/file02.txt
gs://zadanie4tk/file03.txt
gs://zadanie4tk/file04.txt
gs://zadanie4tk/file05.txt
```

### 1.2 Przygotowanie `VM`
>Domyślne ustawienia Cloud API access scopes dla nowo tworzonego VM są takie, że maszyna ma dostęp do bucet w trybie "Read Only". Wiec nie ma co tu majstrować.
Service account też zostanie domyślne.
```bash
#Zmienne
vmName="vmzadanienr4tk" #lokacja brana z configuracji projektu

#Tworzę VM
gcloud compute instances create $vmName --machine-type=f1-micro

#Wynik
[16:19][tomasz@lapek][~/my_repos/Szkola_Chmury] $ gcloud compute instances list 
NAME            ZONE            MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
vmzadanienr4tk  europe-west1-b  f1-micro                   10.132.0.12  35.205.9.231  RUNNING
```

### 1.3 Logowanie i sprawdzenie uprawnień
```bash
#Loguję się na VM
gcloud compute ssh vmzadanienr4tk

#Sprawdzam uprawnienia
tomasz@vmzadanienr4tk:~$ gsutil ls
gs://zadanie4tk/
gs://billing_bucket_tk/
```
> Oto problem tego rozwiązania. Widać wszystkie buckety w projekcie.
```bash
#Lista plików na bucket
tomasz@vmzadanienr4tk:~$ gsutil ls gs://zadanie4tk/
gs://zadanie4tk/file01.txt
gs://zadanie4tk/file02.txt
gs://zadanie4tk/file03.txt
gs://zadanie4tk/file04.txt
gs://zadanie4tk/file05.txt

#Próba odczytu z zasobów - działa
tomasz@vmzadanienr4tk:~$ gsutil cat gs://zadanie4tk/file01.txt
We diminution preference thoroughlyif. Joy deal pain view much her time....

#Próba usunięcia zasobów - już nie
tomasz@vmzadanienr4tk:~$ gsutil rm gs://zadanie4tk/file01.txt
Removing gs://zadanie4tk/file01.txt...
AccessDeniedException: 403 Insufficient Permission

# I w drugą stronę
tomasz@vmzadanienr4tk:~$ echo "ram pam pam, tra la lam" > plik.txt

#Próba zapisu
tomasz@vmzadanienr4tk:~$ gsutil cp plik.txt gs://zadanie4tk/
Copying file://plik.txt [Content-Type=text/plain]...
AccessDeniedException: 403 Insufficient Permission          
```
>Jak widać uprawnienia są OK. Jedyny problem jest taki, że widać wszystkie buckety. Trzeba będzie zmienić Service Account i odebrać uprawnienia do listy bucketów.

### 1.4 Wymiana `Service Account`
```bash
#Zmienne
saName="zadanie4tk"
saEmail="zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com" #gcloud iam service-accounts list

#Tworzę nowe Service Account
gcloud iam service-accounts create $saName \
--description "Konto serwisowe na potrzeby zadania 4" \
--display-name $saName

#Zatrzymuję instancję VM
gcloud compute instances stop $vmName

#Zmieniam konto dla VM
cloud compute instances set-service-account  $vmName \
--service-account=$saEmail

#Start VM z nowym kontem
gcloud compute instances start $vmName

#Loguję się na VM
gcloud compute ssh $vmName
```
### 1.5 Kolejne sprawdzenie uprawnień

```bash
#Sprawdzam uprawnienia
tomasz@vmzadanienr4tk:~$ gsutil ls
AccessDeniedException: 403 zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.buckets.list access to the Google Cloud project.

tomasz@vmzadanienr4tk:~$ gsutil ls gs://zadanie4tk/
AccessDeniedException: 403 zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.objects.list access to the Google Cloud Storage bucket.
```
>Nowe konto nie ma nawet prawa do odczytu, więc je nadam.

### 1.6 Dodawanie uprawnień odczytu do SA
```bash

#Przydzielanie roli do Service Account
gcloud projects add-iam-policy-binding szkola-chmury-tk \
--member serviceAccount:$saEmail \
--role roles/storage.objectViewer

#wuynik
tomasz@vmzadanienr4tk:~$ gsutil ls
AccessDeniedException: 403 zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.buckets.list access to the Google Cloud project.
tomasz@vmzadanienr4tk:~$ gsutil ls gs://zadanie4tk/
gs://zadanie4tk/file01.txt
gs://zadanie4tk/file02.txt
gs://zadanie4tk/file03.txt
gs://zadanie4tk/file04.txt
gs://zadanie4tk/file05.txt

tomasz@vmzadanienr4tk:~$ gsutil cp plik.txt gs://zadanie4tk/
Copying file://plik.txt [Content-Type=text/plain]...
AccessDeniedException: 403 Insufficient Permission             
```
>Teraz lepiej

# 1. Zadanie 2

