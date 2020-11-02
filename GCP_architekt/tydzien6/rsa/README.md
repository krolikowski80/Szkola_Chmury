# [Regulating Storage Access](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-6-cloud-storage/regulating-storage-access-hands-on/)


## [Upublicznianie danych Cloud Storage](https://cloud.google.com/storage/docs/access-control/making-data-public)

## [Tworzenie list ACL i zarządzanie nimi](https://cloud.google.com/storage/docs/access-control/create-manage-lists)

## [Dzienniki Cloud Storage](https://cloud.google.com/storage/docs/access-logs)

```bash
#Utwórz zasobnik
gsutil mb gs://gcp-bucket-nr1

#skopiuj do niego dane lokalne.
gsutil -m cp * gs://gcp-bucket-nr1

#Ustaw dane przechowywania na 30 sekund w zasobniku.
gsutil retention set 30s gs://gcp-bucket-nr1

#Spróbuj usunąć plik z zasobnika.
gsutil rm gs://gcp-bucket-nr1/img4.jpg

#Następujące polecenie wykonuje zmianę (acl ch), przyznając użytkownikowi AllUsers (-u) uprawnienia do odczytu (R) w pliku img3.jpg.
gsutil acl ch -u AllUsers:R gs://gcp-bucket-nr1/img3.jpg

#Do stworzenia podpisanego adresu URL wymagany jest moduł pyopenssl. Można go zainstalować za pomocą polecenia.
sudo pip install pyopenssl

#Lista dostępnych kont usług.
gcloud iam service-accounts list

#Tworzenie klucza prywatnego przy użyciu wskazanego konta usługi.
gcloud iam service-accounts keys create key.json --iam-account <ACC>

#Wykorzystanie utworzonego klucza prywatnego do stworzenia podpisanego adresu URL, który będzie trwał 10 minut (-d 10m) w pliku img1.jgp.
gsutil signurl -d 10m key.json gs://gcp-bucket-nr1/img1.jgp
```