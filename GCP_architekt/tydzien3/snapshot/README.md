# [Snapshot](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-3-compute-engine/snapshots/)

### 1. Profile konfiguracyjne
```bash
# Lista projektów
gcloud projects list

# Sprawdzenie profilu konfiguracyjnego - domyślne wartości
gcloud config list

# Lista konfiguracji
gcloud config configurations list

# Tworzenie nowej konfiguracji
gcloud config configurations create szkola-chmury-tk-conf

# Ustawienie projektu
gcloud config set project <Nazwa lub ID projektu>

# Lista dostępnych regionów
gcloud compute regions list

# Ustawienie domyślnego regionu dla compute
gcloud config set compute/region us-central1
```

### 2. Tworzenie VM
```bash
# Tworzenie instancji VM o nazwie vm01, typie f1-micro i w zonie europe-west1-b
cloud compute instances create vm01 \
--machine-type=f1-micro \
--zone=europe-west1-b

# Tworzenie dysku
gcloud compute disks create vm01disk \
--size=50GB \
--zone=europe-west1-b

# Lista dysków
 gcloud compute disks list

# Podłączanie dysku do VM
gcloud compute instances attach-disk vm01 \
--disk vm01disk \
--zone=europe-west1-b
```

### 3. Połączenie się do VM przez SSH
```bash
# Logowanie przez SSH do VM
gcloud compute ssh vm01 \
--zone=europe-west1-b

# podgląd dysków
sudo lsblk

# formatowanie dysku
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

# podpięcie dysku do folderu
sudo mkdir -p /disk2
sudo mount -o discard,defaults /dev/sdb /disk2
sudo chmod a+w /disk2

# utworzenie pliku na dysku
cd /disk2
echo "test1" > file1.txt
cat file1.txt
```

### 4. Tworzenie snapshota
```bash
# Stworzenie snapshota dysku
gcloud compute disks snapshot vm01disk \
--snapshot-names vm01disk-snapshot \
--zone=europe-west1-b

# Sprawdzenie snapshotów
gcloud compute snapshots list
```

### 5. Wykorzystanie snapshota do utworzenia nowego dysku
```bash
# Utworzenie nowej instancji VM
gcloud compute instances create vm02 \
--machine-type=f1-micro \
--zone=us-central1-c

# Utworznie dysku ze snapshota
gcloud compute disks create vm02disk --source-snapshot=vm01disk-snapshot \
--zone=us-central1-c

# Podpięcie dysku do VM
gcloud compute instances attach-disk vm02 \
--disk vm02disk \
--zone us-central1-c
```
### 7. Usunięcie zasobów
```bash
# Odpięcie dysków z VM
gcloud compute instances detach-disk vm01 \
--disk vm01disk \
--zone europe-west1-b

gcloud compute instances detach-disk vm02 \
--disk vm02disk \
--zone us-central1-c

# Lista instancji
gcloud compute instances list

# Usunięcie instancji VM
gcloud compute instances delete vm01 --zone=europe-west1-b
gcloud compute instances delete vm02 --zone=us-central1-c

# Usunięcie dysków
gcloud compute disks delete vm01disk --zone=europe-west1-b
gcloud compute disks delete vm02disk --zone=us-central1-c

# Usunięcie shapshota
gcloud compute snapshots delete vm01disk-snapshot
```