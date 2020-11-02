# [Cloud Storage Concepts (Deep Dive)](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-6-cloud-storage/cloud-storage-concepts-deep-dive/)

# [Tworzenie i używanie zasobników Cloud Storage] (https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-6-cloud-storage/creating-and-using-cloud-storage-buckets/)

## Dokumentacja
### [Cloud Storage Concepts](https://cloud.google.com/storage/docs/concepts)

### [Cloud Storage best practices](https://cloud.google.com/storage/docs/best-practices)

### [How-to guides](https://cloud.google.com/storage/docs/how-to)

```bash
#Równoległa kopia plików lokalnych do zasobnika Cloud Storage.
gsutil -m cp * gs://gcp-bucket-nr1

#Wyświetl całkowity rozmiar wszystkich obiektów z zasobnika.
gsutil du -s gs://gcp-bucket-nr1

#Wyświetl informacje o metadanych zasobnika.
gsutil ls -L -b gs://gcp-bucket-nr1

#Tworzenie zasobnika ze „standardową” klasą pamięci i w regionie „us-east1”.
gsutil mb -c standard -l us-east1 gs://gcp-bucket-nr2

#Skopiuj wszystkie dane z „gcp-bucket-n1” do „gcp-bucket-nr2”.
gsutil cp gs://gcp-bucket-n1/** gs://gcp-bucket-nr2

#Wypisz wszystkie dane z bucket-nr2.
gsutil ls -r gs://gcp-bucket-nr2/**

#Zmień domyślną klasę pamięci z „gcp-bucket-nr2” na „nearline”.
gsutil defstorageclass set nearline gs://gcp-bucket-nr2

#Skopiuj pojedynczy plik „file.txt” do zasobnika „„ gcp-bucket-nr2 ”.
gsutil cp file.txt gs://gcp-bucket-nr2
```