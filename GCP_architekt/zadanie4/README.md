 [Zadanie domowe nr 4](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/zadanie-domowe-nr-4/)

* [1. Zadanie 1](#1-zadanie-1)
    * [1.2 Przygotowanie `Cloud Storage`](#11-przygotowanie-cloud-storage)

# 1. Zadanie 1

> Klient poprosił cię o przygotowanie maszyny dla swoich pracowników, którzy będą mogli pobierać faktury z przygotowanego repozytorium (w naszym przypadku jest to pojemnik Cloud Storage)


### 1.1 Przygotowanie `Cloud Storage`
```bash
#Zmienne
bucketName="zadanie4tk"
bucketLoc="us-west1"
saAccountName="tkzad4"

#Dodane po utprzeniu SA
serviceAccountName="tkzad4@szkola-chmury-tk.iam.gserviceaccount.com"

#Tworzę bukiecik
* Region buketa można było pozostawić na taki, jaki jest w configuracji CLI
gsutil mb -l $bucketLoc gs://${bucketName}/

#Tworzeę Service Accunt
gcloud iam service-accounts create $saAccountName \
--description "Konto serwisowe do VM w zadaniu nr 4" \
--display-name "konto do VM"

#lista kont serwisowych - sprawdzam adres email nowego SA
gcloud iam service-accounts list

