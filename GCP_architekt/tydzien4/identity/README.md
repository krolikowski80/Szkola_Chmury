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
## 2. Service Accounts
```bash
#Tworzenie Service Accunt
gcloud iam service-accounts create [SA-NAME] --description "[SA-DESCRIPTION]" --display-name "[SA-DISPLAY-NAME]"
```

```bash
#Listowanie Service Accunt
gcloud iam service-accounts list
```

```bash
#Tworzenie kluczy 
gcloud iam service-accounts keys create [/path/to/key_name.json] --iam-account [SA-NAME]@[PROJECT-ID].iam.gserviceaccount.com
```

## 3. Niestandardowe role
```bash
naono role.yml

#Dodajemy rolę do przeglądania ról
title: "Role Viewer"
description: "My custom role description."
stage: "ALPHA"
includedPermissions:
- iam.roles.get
- iam.roles.list
```

```bash
#Aktualizacja zasad w wybranym projekcie
gcloud iam roles create [role-id] --project my-project-id --file role.yaml
```

```bash
#Pokaż wszystkie role
gcloud iam roles list
```

```bash
#Opis konkretnej roli
gcloud iam roles describe [role-id] --project [my-project-id]
```

## 4. Zarządzanie zasadami organizacji
```bash
#Wyświetl bieżące zasady „compute.trustedImageProjects” dla projektu i zapisanie ich w pliku
gcloud beta resource-manager org-policies describe compute.trustedImageProjects --effective  --project <PROJECT_ID> > file_policy.yaml
```
```bash
#Lista dostępnych obrazów
gcloud compute images list
```

```bash
#Modyfikacja istniejącej polityki - file_policy.yaml - aby odmówić dostęppu do wybranych obrazów
cat file_policy.yaml 

constraint: constraints/compute.trustedImageProjects
listPolicy:
  allValues: ALLOW


nano file_policy.yaml
constraint: constraints/compute.trustedImageProjects
listPolicy:
  deniedValues:
    - projects/debian-cloud
```
```bash
#Wysyłanie zmian    
gcloud beta resource-manager org-policies set-policy --project <PROJECT_ID> file_policy.yaml
```
