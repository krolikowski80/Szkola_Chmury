# [Working with Cryptographic Keys](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/working-with-cryptographic-keys-hands-on/)

* [Key Management Service Concepts](https://cloud.google.com/kms/docs/concepts)

* [Creating symmetric keys](https://cloud.google.com/kms/docs/creating-keys)

* [Creating asymmetric keys](https://cloud.google.com/kms/docs/creating-asymmetric-keys)

```bash
# Utworzenie bucketa w usłudze Cloud Storage
gsutil mb gs://<BUCKET_NAME>

# Włączenie api dla usługi KMS
gcloud services enable cloudkms.googleapis.com

# Utworzenie globalnego keyring
gcloud kms keyrings create <KEYRING_NAME>

# Sprawdzenie listy keyringów
gcloud kms keyrings list \
--location=<KEYRING_LOCATION>

# Utworzenie symetrycznego klucza do szyfrowania danych
gcloud kms keys create <CRYPTOKEY_NAME> \
--location global \
--keyring <KEYRING_NAME> \
--purpose encryption

# Sprawdzenie listy kluczy
gcloud kms keys list \
--keyring=<KEYRING_NAME> \
--location=<KEYRING_LOCATION>

# Sformatowanie tekstu z pliku do base64
TEXT=$(cat <FILE_NAME> | base64 -w0)

# Wywołanie API do szyfrowania danych
curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type: application/json"
  | jq .ciphertext -r > <ENCRYPTED_FILE_NAME>

# Wywołanie API do odszyfrowania danych
curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:decrypt" \
  -d "{\"ciphertext\":\"$(cat <ENCRYPTED_FILE_NAME)\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type: application/json"
```
## Ćwiczenia z [qwiklabs](https://www.qwiklabs.com/)
>W KMS istnieją dwa główne uprawnienia, na których można się skupić. Jedno uprawnienie umożliwia użytkownikowi lub kontu usługi zarządzanie zasobami KMS,a drugie umożliwia użytkownikowi lub kontu usługi używanie kluczy do szyfrowania i odszyfrowywania danych.

```bash
#zmienne
BUCKET_NAME=mybucketname

#Tworzę bucket
gsutil mb gs://${BUCKET_NAME}

#Przypisuję temu użytkownikowi możliwość zarządzania zasobami KMS
gcloud kms keyrings add-iam-policy-binding <KEYRING_NAME> \
--location global \
--member user:$USER_EMAIL \
--role roles/cloudkms.admin

#Przypisanie uprawnień do szyfrowania i odszyfrowywania danych i użycia dowolnego klucza CryptoKey w utworzonym KeyRingu
gcloud kms keyrings add-iam-policy-binding <KEYRING_NAME> \
--location global \
--member user:$USER_EMAIL \
--role roles/cloudkms.cryptoKeyEncrypterDecrypter
```
>Teraz, gdy wiesz, jak zaszyfrować pojedynczy plik i masz do tego uprawnienia, możesz uruchomić skrypt, aby wykonać kopię zapasową wszystkich plików w katalogu. W tym przykładzie skopiuj wszystkie e - maile do allen-p , zaszyfruj je i prześlij do zasobnika Cloud Storage.

```bash
#Skopiuj wszystkie pliki z bucket/katalog do bieżącego katalogu roboczego
gsutil -m cp -r gs://enron_emails/allen-p .

#Wykonuję kopię zapasową i szyfruję wszystkie pliki z katalogu allen-p w swoim zasobniku Cloud Storage
MYDIR=allen-p
FILES=$(find $MYDIR -type f -not -name "*.encrypted")
for file in $FILES; do
  PLAINTEXT=$(cat $file | base64 -w0)
  curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
    -d "{\"plaintext\":\"$PLAINTEXT\"}" \
    -H "Authorization:Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type:application/json" \
  | jq .ciphertext -r > $file.encrypted
done
gsutil -m cp allen-p/inbox/*.encrypted gs://${BUCKET_NAME}/allen-p/inbox
```