 # [Zadanie nr 4](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/zadanie-domowe-nr-4/)

* [1. Zadanie 1](#1-zadanie-1)
    * [1.1 Przygotowanie `Cloud Storage`](#11-przygotowanie-cloud-storage)
    * [1.2 Przygotowanie `VM`](#12-Przygotowanie-VM)
    * [1.3 Logowanie i sprawdzenie uprawnień](#13-logpwanie-i-sprawdzenie-uprawnień)
    * [1.4 Wymiana `Service Account`](#14-wymiana-service-account)
    * [1.5 Kolejne sprawdzenie uprawnień](#15-kolejne-sprawdzenie-uprawnień)
    * [1.6 Dodawanie uprawnień odczytu do SA](#16-dodawanie-uprawnień-odczytu-do-sa)
    * [1.7 Usunięcie zasobów](#17-usunięcie-zasobóww)
* [2. Zadanie 2](#2-zadanie-2)
    * [2.1 Utworzenie storage](#21-utworzenie-storage])
    * [2.2 Utworzenie Service Account z prawem RW do storage](#22-Utworzenie-Service-Account-z-prawem-RW-do-storage)
    * [2.3 Uruchomienie usługi KMS](#23-Uruchomienie-usługi-KMS)
    * [2.4 Utworzenie keyring, kluczy symetrychnych i asymetrycznych](#24-Utworzenie-keyring,-kluczy-symetrychnych-i-asymetrycznych])
    * [2.5 Przydział uprawnień dla SA do keyringa](#25-Przydział-uprawnień-dla-SA-do-keyringa)
    * [2.6 Utworzenie VM pod kontrolą SA](#26-Utworzenie-VM-pod-kontrolą-SA)
    * [2.7 Logowanie na maszyny i szyfrowanie](#27-Logowanie-na-maszyny-i-szyfrowanie])
      * [2.7.1 Szyfrowanie asymetryczne](#271-Szyfrowanie-asymetryczne)
      * [2.7.2 Odszyfrowanie asymetryczne](#272-Odszyfrowanie-aymetryczne)
      * [2.7.3 Szyfrowanie symetryczne](#273-Szyfrowanie-symetryczne)
      * [2.7.4 Odszyfrowanie symetryczne](#274-Odszyfrowanie-symetryczne])
    * [2.8 Usuwanie zaspbów](#28-Usuwanie-zaspbów)
        
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
#Dodaję prawa do odczytu dla SA do konkretnego bucketa
gsutil iam ch serviceAccount:$saEmail:roles/storage.legacyBucketReader gs://${bucketName}/

#wynik
gcloud compute ssh $vmName

tomasz@vmzadanienr4tk:~$ gsutil ls gs://zadanie4tk/
gs://zadanie4tk/file01.txt
gs://zadanie4tk/file02.txt
gs://zadanie4tk/file03.txt
gs://zadanie4tk/file04.txt
gs://zadanie4tk/file05.txt
tomasz@vmzadanienr4tk:~$ gsutil ls
AccessDeniedException: 403 zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.buckets.list access to the Google Cloud project.
tomasz@vmzadanienr4tk:~$ gsutil ls gs://billing_bucket_tk/
AccessDeniedException: 403 zadanie4tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.objects.list access to the Google Cloud Storage bucket.
```
>Teraz lepiej

### 1.7 Usunięcie zasobów
```bash
#Usuwam VM
gcloud compute instances delete $vmName

#Usuwam SA
gcloud iam service-accounts delete $saEmail

#Usuwam storage
gsutil rm -r gs://${bucketName}/
```

# 2. Zadanie 2
>Dany klient przetrzymuje bardzo ważne dokumenty. Zarząd zdecydował, że wprowadzą szyfrowanie krytycznych dokumentów, które będą mogły zostać odszyfrowane po stronie pracownika, który z danego dokumentu chce skorzystać.

### 2.1 Utworzenie storage
```bash
#Zmienne
bucketName="zadanie42tk"
bucketReg="us-central1"

#Tworzę storage
gsutil mb -l $bucketReg gs://${bucketName}/
```

### 2.2 Utworzenie Service Account z prawem RW do storage
```bash
#Zmienne
saName="zad42tk"
saEmail="zad42tk@szkola-chmury-tk.iam.gserviceaccount.com" #gcloud iam service-accounts list 

#Tworzenie Service Account
gcloud iam service-accounts create $saName \
--display-name=$saName

#Przydział prawa RW do danego stgorage
gsutil iam ch serviceAccount\
:$saEmail\
:roles/storage.objectAdmin \
gs://${bucketName}
```
### 2.3 Uruchomienie usługi KMS
```bash
# Włączenie api dla usługi KMS
gcloud services enable cloudkms.googleapis.com
```

### 2.4 Utworzenie keyring, kluczy symetrychnych i asymetrycznych
```bash
#Zmienne
keyRing="zad4ring"
syncKey="synckey"
asyncKey="asynckey"

gcloud kms keyrings create serviceAccount\
--location=global

# Utworzenie symetrycznego klucza do szyfrowania danych
gcloud kms keys create $syncKey \
--location global \
--keyring $keyRing \
--purpose encryption

# Utworzenie pary kluczy asymetrycznych
gcloud kms keys create $asyncKey \
--location global \
--keyring $keyRing \
--purpose asymmetric-encryption \
--default-algorithm rsa-decrypt-oaep-4096-sha256 \
--protection-level software
```

### 2.5 Przydział uprawnień(roli) dla SA do keyringa
```bash
#pobranie polityki dla keyring
gcloud kms keyrings get-iam-policy $keyRing --location global > kms_keyring.yaml

#edycja polityki
bindings:
- members:
  - serviceAccount:zad42tk@szkola-chmury-tk.iam.gserviceaccount.com
  role: roles/cloudkms.cryptoKeyEncrypterDecrypter
- members:
  - serviceAccount:zad42tk@szkola-chmury-tk.iam.gserviceaccount.com
  role: roles/cloudkms.publicKeyViewer
etag: BwWu0mSQSSk=
version: 1

#ustawienie polityki
gcloud kms keyrings set-iam-policy $keyRing --location global kms_keyring.yaml
```

### 2.6 Utworzenie VM pod kontrolą SA
```bash
#Zmienne
vm1name="instance1"
vm2name="instance2"

#utworzenie maszyny 1
gcloud compute instances create $vm1name \
--machine-type f1-micro \
--zone=europe-west1-b \
--service-account=$saEmail \
--scopes https://www.googleapis.com/auth/cloudkms,https://www.googleapis.com/auth/devstorage.read_write

#utworzenie maszyny 2
gcloud compute instances create $vm2name \
--machine-type f1-micro \
--zone=us-central1-b \
--service-account=$saEmail \
--scopes https://www.googleapis.com/auth/cloudkms,https://www.googleapis.com/auth/devstorage.read_write
```

### 2.7 Logowanie na maszyny i szyfrowanie
```bash
#Jest dostep?
tomasz@instance1:~$ gsutil ls gs://zadanie42tk/
gs://zadanie42tk/file01.txt
gs://zadanie42tk/file02.txt
gs://zadanie42tk/file03.txt
gs://zadanie42tk/file04.txt
gs://zadanie42tk/file05.txt

#A innego bucketa?
gsutil ls gs://billing_bucket_tk/
AccessDeniedException: 403 zad42tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.objects.list access to the Google Cloud Storage bucket.

#A lista?
gsutil ls
AccessDeniedException: 403 zad42tk@szkola-chmury-tk.iam.gserviceaccount.com does not have storage.buckets.list access to the Google Cloud project.

```

#### 2.7.1 Szyfrowanie asymetryczne
```bash
#Loguję się na maszynie nr 1
gcloud compute ssh $vm1name

#Kopiuje pliki lokalnie
mkdir encrypted && mkdir decrypted && gsutil -m cp gs://zadanie42tk/* decrypted/

#Pobieram klucz pubiczny
gcloud kms keys versions get-public-key 1 \
--key $asyncKey  \
--keyring $keyRing \
--location global \
--output-file ~/asyncKey.pub

#Szyfruję asymetrycznie 5 plików
files=$(ls ~/decrypted/)
cd ~/decrypted/
for f in $files ; do
    openssl pkeyutl -in $f \
    -encrypt \
    -pubin \
    -inkey ~/asyncKey.pub \
    -pkeyopt rsa_padding_mode:oaep \
    -pkeyopt rsa_oaep_md:sha256 \
    -pkeyopt rsa_mgf1_md:sha256  > ~/encrypted/$f.enc
done

#Kopiuję do storge
gsutil -m cp -r encrypted/ gs://zadanie42tk/

#Sprawdzam
sutil ls gs://zadanie42tk/encrypted/
gs://zadanie42tk/encrypted/file01.txt.enc
gs://zadanie42tk/encrypted/file02.txt.enc
gs://zadanie42tk/encrypted/file03.txt.enc
gs://zadanie42tk/encrypted/file04.txt.enc
gs://zadanie42tk/encrypted/file05.txt.enc
```

#### 2.7.2 Odszyfrowanie asymetryczne
```bash
#Loguję się na maszynie nr 2
gcloud compute ssh $vm2name

# Kopiuje pliki lokalnie
mkdir encrypted && mkdir decrypted && gsutil -m cp gs://zadanie42tk/encrypted/* encrypted/

#Dekoduje plik
gcloud kms asymmetric-decrypt \
--version 1 \
--key asynckey \
--keyring zad4ring \
--location global  \
--ciphertext-file ~/encrypted/file01.txt.enc \
--plaintext-file ~/decrypted/file01.txt

#Działa
cat decrypted/file01.txt 
We diminution preference thoroughly if....
```
#### 2.7.3 Szyfrowanie symetryczne
```bash
#Loguję się na maszynie nr 2
gcloud compute ssh $vm2name

#Kopiuje pliki lokalnie
mkdir encrypted && mkdir decrypted && gsutil -m cp gs://zadanie42tk/* decrypted/

#Koduję symetrycznie
gcloud kms encrypt \
--key $syncKey \
--keyring $keyRing \
--location global \
--plaintext-file ~/decrypted/file01.txt \
--ciphertext-file ~/encrypted/file01.txt.enc

#Sprawdzam i działa
tomasz@instance2:~$ ls encrypted/
file01.txt.enc

#Kopiuję plik na storage
cp encrypted/file01.txt.enc gs://zadanie42tk/encrypted/
```

#### 2.7.4 Odszyfrowanie symetryczne
```bash
#Loguję się na maszynie nr 1
gcloud compute ssh $vm1name

#Odszyfrowanie pliku
gcloud kms decrypt \
--key $syncKey \
--keyring $keyRing \
--location global \
--ciphertext-file encrypted/file01.txt.enc \
--plaintext-file decrypted/file01.txt

#Sprawdzam
tomasz@instance1:~$ cat decrypted/file01.txt 
We diminution prefer....
```

### 2.8 Usuwanie zaspbów
```bash
#usuwanie instancji
gcloud compute instances delete instance1
gcloud compute instances delete instance2

#Usuwanie bucketa
 gsutil rm -r gs://${bucketName}

#Usuwanie Service account
gcloud iam service-accounts delete $saEmail
```
# 3. Zadanie 3
> Firma zdecydowała się już na ostatni krok ... zbudowanie niestandardowej roli za pomocą, której połączą możliwości szyfrowania oraz odszyfrowywania danych za pomocą KMS oraz dostępu do danych w Cloud Storage na poziomie READ

### 3.1 Tworzenie Service Account
```bash
#Zmienne
saName="zadanie43tk"
saEmail="zadanie43tk@szkola-chmury-tk.iam.gserviceaccount.com" #gcloud iam service-accounts list 

#Tworzę Service Account
gcloud iam service-accounts create $saName --display-name=$saName
```
### 3.2 Tworzenie roli niestandardowej
```bash
#Zmienne
projectID=szkola-chmury-tk
roleID=read_dec_enc
roleDefinition=/home/tomasz/my_repos/Szkola_Chmury/dostep.yaml
rolePath=projects/szkola-chmury-tk/roles/read_dec_enc #gcloud iam roles list --project $projectID


#Tworzę pliku roli niestandardowej 
title: "Dostep do kluczy i storage"
description: "rola za pomocą, której konto ma  możliwości szyfrowania oraz odszyfrowywania danych za pomocą KMS oraz dostępu do 
danych w Cloud Storage na poziomie READ"
stage: "GA"
includedPermissions:
- storage.objects.get
- storage.objects.list
- cloudkms.cryptoKeyVersions.useToDecrypt
- cloudkms.cryptoKeyVersions.useToEncrypt
- cloudkms.cryptoKeyVersions.viewPublicKey

#Tworzenie roli na podstawie pliku
gcloud iam roles create $roleID \
--project $projectID
--file $roleDefinition

#Sprawdzam role
gcloud iam roles list --project $projectID

#Bindowanie roli do SA
gcloud projects add-iam-policy-binding $projectID \
--member serviceAccount:$saEmail \
--role $rolePath
```

### 3.3 Tworzenie bucketu
```bash
#Zmienne
bucketName=zadanie43tk
bucketLocation=us-central2

#TGworzę bucket
gsutil mb -l $bucketLocation gs://${bucketName}
```



DAlsze kroki

utworzenie bucket
utworzenie VM
i testy