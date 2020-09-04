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

# Utworzenie symetrycznego klucza do szyfrowania danych
gcloud kms keys create <CRYPTOKEY_NAME> \
--location global \
--keyring <KEYRING_NAME> \
--purpose encryption

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