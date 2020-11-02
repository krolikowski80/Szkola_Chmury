# [Object Versioning and Lifecycle Management](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-6-cloud-storage/object-versioning-and-lifecycle-management-hands-on/)


### Utwórz zasady zarządzania klasami pamięci masowej
```bash
#Utwórz bucket za pomocą polecenia:
gsutil mb gs://$bucketName/

#Utwórz na komputerze plik JSON o nazwie lifecycleman.json

#Utwórz zasadę dla zasobnika:
gsutil lifecycle set lifecycleman.json gs://$bucketName/

# Sprawdź zasady dotyczące zasobnika:
gsutil lifecycle get gs://$bucketName/
```

### Utwórz zasady usuwania
```bash
#Sprawdź stan wersji zasobnika:
gsutil versioning get gs://$bucketName/

#Włącz przechowywanie wersji dla zasobnika:
gsutil versioning set on gs://$bucketName/

#Utwórz plik json z zasadami rules.jason

#Utwórz zasadę dla zasobnika:
gsutil lifecycle set ver_rules.json gs://$bucketName/

#Sprawdź zasady dotyczące zasobnika:
gsutil lifecycle get gs://$bucketName/

#Prześlij plik do pamięci:
gsutil cp ver_rules.json gs://$bucketName/policy/ver_rules.json

#Usunąć plik:
gsutil rm gs://$bucketName/policy/ver_rules.json

#Wyświetl wszystkie pliki w pamięci:
gsutil ls gs://$bucketName/

#Lista plików z danymi generacji (i nieaktualnymi wersjami):
gsutil ls -a gs://$bucketName/
gsutil ls -a gs://$bucketName/policy

#Skopiuj wersję nieużywaną do pamięci:
gsutil cp gs://week5bucket/policy/ver_rules.json#1603747322554653 gs://week5bucket/policy/ver_rules_restore.json
```