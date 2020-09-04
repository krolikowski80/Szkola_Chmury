# [Migration, Duplication and Moving Machines](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-3-compute-engine/migration-duplication-and-moving-machines-hands-on/)

### 1. Przeniesienie VM pomiędzy zonami w tym samym regionie
```bash
#lista instancji VM
gcloud compute instances list

# Proste przenoszenie pomiędzy zonami us-east1-c a us-east1-b
gcloud compute instances move nazwa_instancji --zone=us-east1-c --destination-zone us-east1-b
```
### 2. Przenoszenie do innego regionu
```bash
# Lista dostępnych regionów
gcloud compute zones list

# Lista dysków
gcloud compute disks list

# Wyłączam autodelete dysku, która zawsze domyślnie jest włączona
gcloud compute instances set-disk-auto-delete <nazwa_instancji> \
--zone=us-east1-b \
--disk <nazwa_dysku> \
--no-auto-delete

# Utworzenie snapshot dysku
gcloud compute disks snapshot <NAZWA_DYSKU> --snapshot-names <NAZWA_SNAPSHOTA> --zone=us-east1-b

# Lista snapshotów
gcloud compute snapshots list

# Stworzenie dysku w nowym regionie
gcloud compute disks create my-wordpress-disk \
--source-snapshot my-wordpres-snapshot \
--zone eeurope-west1-b

# Stworzenie VM w nowym regionie
gcloud compute instances create my-wordpress-vm \
--machine-type f1-micro \
--zone europe-west1-b \
--disk name=my-wordpress-disk,boot=yes,mode=rw


# Dodanie reguły firewall
gcloud compute instances add-tags my-wordpress-vm --zone europe-west1-b --tags http-server
```

### 3. Usunięcie zasobów
```bash
# Usunięcie VM
gcloud compute instances list
gcloud compute instances delete <INSTANCE_NAME> --zone=<REGION-ZONE>

# Usunięcie dysków
gcloud compute disks list
gcloud compute disks delete <DISK_NAME> --zone=<REGION-ZONE>

# Usunięcie snapshotów
gcloud compute snapshots list
gcloud compute snapshots delete <SNAPSHOT_NAME>

# Usunięcie reguły firewall, którą utworzyła 1 instancja
gcloud compute firewall-rules list
gcloud compute firewall-rules delete <RULERS_NAME>
```