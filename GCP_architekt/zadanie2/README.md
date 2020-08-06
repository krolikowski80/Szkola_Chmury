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
gcloud compute instances move instance-1 --zone europe-west3-b --destination-zone europe-west3-a
Moving gce instance instance-1...done.
```