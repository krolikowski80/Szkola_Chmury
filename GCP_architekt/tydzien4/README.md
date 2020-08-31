# [Cloud identity and access management](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/)

## 1. Zarządzanie rolami i uprawnieniami
```bash
#Dodaję użytkownikowi dostęp do projektu jako przeglądający
gcloud projects add-iam-policy-binding [projectid] --member user:user@example.com --role roles/viewer
```

```bash
#Odbieranie uprawnień
gcloud projects remove-iam-policy-binding [projectid] --member user:user@example.com --role roles/viewer
```

```bash
#Eksportowanie polityki uprawnień do pliku json
gcloud projects get-iam-policy [projectid] --format json > ~/policy.json
```