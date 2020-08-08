# [Zadanie domowe nr 2](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-2-podstawy-pracy-z-gcp/zadanie-domowe-nr-2/)

# Billing

### 1. Eksport danych rozliczeniowych do BigQuery

#### 1.1 Utworzenie Dataset z BigQuery

<details>
  <summary><b><i>Pokaż</i></b></summary>

![BigQuery](./img/dataset.jpg "BigQuery")
![BigQuery](./img/dataset2.jpg "BigQuery")
</details>

#### 1.2 Eksport bilingu do BigQuery

<details>
  <summary><b><i>Pokaż</i></b></summary>

![BigQuery](./img/eksport1.jpg "Export")
![BigQuery](./img/eksport2.jpg "Export")
![BigQuery](./img/eksport3.jpg "Export")
</details>

### 2. Eksport danych rozliczeniowych do pliku

#### 2.1 Utworzenie Bucketa w Cloud Storage

<details>
  <summary><b><i>Pokaż</i></b></summary>

![CloudStorage](./img/bucket1.jpg "CloudStorage")
![CloudStorage](./img/bucket2.jpg "CloudStorage")
![CloudStorage](./img/bucket3.jpg "CloudStorage")
![CloudStorage](./img/bucket4.jpg "CloudStorage")
</details>

#### 2.1 Eksport danych do pliku CSV

<details>
  <summary><b><i>Pokaż</i></b></summary>

![CloudStorage](./img/plik_csv1.jpg "CloudStorage")
![CloudStorage](./img/plik_csv2.jpg "CloudStorage")
![CloudStorage](./img/plik_csv3.jpg "CloudStorage")
</details>

# Compute Engine

### 3.1 Utworzenie oraz uruchamianie instancji

<details>
  <summary><b><i>Pokaż</i></b></summary>

![ComputeEngine](./img/instancja1.jpg "ComputeEngine")
![ComputeEngine](./img/instancja2.jpg "ComputeEngine")
</details>

### 3.2 Odłączenie dysku startowego

<details>
  <summary><b><i>Pokaż</i></b></summary>

![ComputeEngine](./img/odlaczanie1.jpg "ComputeEngine")
![ComputeEngine](./img/odlaczanie2.jpg "ComputeEngine")
![ComputeEngine](./img/odlaczanie3.jpg "ComputeEngine")
</details>

### 3.3 Ponowne podłączenie dysku startowego

<details>
  <summary><b><i>Pokaż</i></b></summary>

![ComputeEngine](./img/podlaczenie1.jpg "ComputeEngine")
![ComputeEngine](./img/podlaczenie2.jpg "ComputeEngine")
![ComputeEngine](./img/podlaczenie3.jpg "ComputeEngine")
</details>

### 3.4 Snapshot dysku

<details>
  <summary><b><i>Pokaż</i></b></summary>

![ComputeEngine](./img/snapshot1.jpg "ComputeEngine")
![ComputeEngine](./img/snapshot2.jpg "ComputeEngine")
</details>

### 3.5 Przenoszenie instancji pomiędzy strefami

```bash
gcloud compute instances move instance-1 \
  --zone europe-west3-b \
  --destination-zone europe-west3-a
Moving gce instance instance-1...done.
```

### 3.6 Przenoszenie instancji pomiędzy regionami

#### 3.6.1 Stworzenie dysku ze snapshota
Wyświetlenie wszystkich dysków
```bash
[22:13][tomasz@lapek][~] $ gcloud compute disks list 
NAME        LOCATION        LOCATION_SCOPE  SIZE_GB  TYPE         STATUS
instance-1  europe-west2-a  zone            10       pd-standard  READY
```

Wyświetlenie snapshotów
```bash
[22:14][tomasz@lapek][~] $ gcloud compute snapshots list 
NAME        DISK_SIZE_GB  SRC_DISK                         STATUS
snapshot-1  10            europe-west2-c/disks/instance-1  READY
```

Sprawdzenie listy dostępnych zone:
```bash
[22:15][tomasz@lapek][~] $ gcloud compute zones list 
NAME                       REGION                   STATUS  NEXT_MAINTENANCE  TURNDOWN_DATE
us-east1-b                 us-east1                 UP
```

Utworzenie nowego dysku ze snapshota
```bash
[22:16][tomasz@lapek][~] $ gcloud compute instances create instance-2 \
  --machine-type f1-micro  \
  --disk name=disc-2,boot=yes,mode=rw  \
  --zone us-east1-b
Created [https://www.googleapis.com/compute/v1/projects/szkola-chmury-tk/zones/us-east1-b/instances/instance-2].
NAME        ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
instance-2  us-east1-b  f1-micro                   10.142.0.2   35.237.118.234  RUNNING
```

Tworzenie skryptu startowego
```bash
[23:08][tomasz@lapek][~] $ echo "#! /bin/bash
apt-get update
apt-get install -y apache2
cat <<EOF > /var/www/html/index.html
<html><body><h1>Hello World</h1>
</body></html>" > starup_script.txt

```

Uruchomienie nowych virtual machine i skryptów startowych
```bash
 [23:11][tomasz@lapek][~] $ gcloud compute instances create vm01-starupscript \
>  --tags=http-server,https-server \
>  --metadata-from-file startup-script=starup_script.txt \
>  --machine-type f1-micro \
>  --zone us-east1-b
Created [https://www.googleapis.com/compute/v1/projects/szkola-chmury-tk/zones/us-east1-b/instances/vm01-starupscript].
NAME               ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
vm01-starupscript  us-east1-b  f1-micro                   10.142.0.6   35.237.118.234  RUNNING
```
Usuwanie istancji
```bash
[23:20][tomasz@lapek][~] $ gcloud compute instances delete vm01-starupscript --zone=us-east1-b
The following instances will be deleted. Any attached disks configured
 to be auto-deleted will be deleted unless they are attached to any 
other instances or the `--keep-disks` flag is given and specifies them
 for keeping. Deleting a disk is irreversible and any data on the disk
 will be lost.
 - [vm01-starupscript] in [us-east1-b]

Do you want to continue (Y/n)?  y

Deleted [https://www.googleapis.com/compute/v1/projects/szkola-chmury-tk/zones/us-east1-b/instances/vm01-starupscript].
```