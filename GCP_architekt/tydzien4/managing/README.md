# [Zasady i role na console.cloud.google.com](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/managing-roles-and-permissions-hands-on/)

### 1. Udzielanie dostępu
    1.1 Otwórz stronę IAM w Cloud Console, używając [linku](https://console.cloud.google.com/iam-admin/iam)

    1.2 Kliknij Wybierz projekt z górnego menu, wybierz projekt i kliknij Otwórz.

    1.3 Kliknij Dodaj.
    
    1.4 Wprowadź adres email. Jako członków możesz dodawać osoby, konta usług lub Grupy dyskusyjne Google, 
    ale każdy projekt musi mieć co najmniej jedną osobę jako członka.
    
    1.5 Wybierz rolę. Role zapewniają członkom odpowiedni poziom uprawnień.

    1.6 Kliknij Zapisz.

### 2. Odwołanie dostępu
    2.1 Otwórz stronę IAM w Cloud Console, używając linku: https://console.cloud.google.com/iam-admin/iam
    
    2.2 Kliknij Wybierz projekt.
    
    2.3 Wybierz projekt i kliknij Otwórz.
    
    2.4 Znajdź członka, któremu chcesz cofnąć dostęp, a następnie kliknij przycisk Edytuj edytuj po prawej stronie.
    
    2.5 Kliknij przycisk Usuń usuń dla każdej roli, którą chcesz odwołać, a następnie kliknij Zapisz.
    
### 3 .Zasady i role używające interfejsu wiersza polecenia gcloud
```bash
#DWANIE użytkownikowi dostępU do projektu jako przeglądający
gcloud projects add-iam-policy-binding [projectid] \
--member user:user@example.com \
--role roles/viewer

#OdwołaNIE dostępU za pomocą polecenia
gcloud projects remove-iam-policy-binding [projectid] \
--member user:user@example.com \
--role roles/viewer

#Eksport zasad do pliku json za pomocą
gcloud projects get-iam-policy [projectid] \
--format json > ~/policy.json
```