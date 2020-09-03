
# [Key Management Service Concepts](https://cloud.google.com/kms/docs/concepts)

# [Creating symmetric keys](https://cloud.google.com/kms/docs/creating-keys)

# [Creating asymmetric keys](https://cloud.google.com/kms/docs/creating-asymmetric-keys)

### 1 Klucze kryptograficzne - KMS(Key Management Service)


```bash
#Zmienne
bucketName="kms-testowy"
bucketLocation="europe-west2"
```
```bash
#Utworzenie bucketa
gsutil mb -c STANDARD -l $bucketLocation gs://${bucketName}/
```
```bash
#Uruchamiam usługę KMS (Key Management Service )
gcloud services enable cloudkms.googleapis.com
```
```bash
#zmienne
keyRingsName="mykeyrings"
keyRingsLoc="global"
keyName="mykey"
```
```bash
#Utworzenie keyringa
gcloud kms keyrings create $keyRingsName \
--location $keyRingsLoc
```
```bash
#Sprawdzam listę keyringów
gcloud kms keys list \
--location $keyRingsLoc \
--keyring $keyRingsName
```
```bash
#Tworzenie klucza szyfrującego
gcloud kms keys create $keyName \
--location $keyRingsLoc \
--keyring $keyRingsName \
--purpose encryption
```
```bash
#Sprawdzam listę kluczy
gcloud kms keyrings list \
--location $keyRingsLoc
```
