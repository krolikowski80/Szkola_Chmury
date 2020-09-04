# [Roles and Custom Roles](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/roles-and-custom-roles-hands-on/)

### 1. Tworzenie niestandardowej roli
    1.1 Kliknij opcję Utwórz rolę.

    1.2 Wprowadź nazwę, tytuł i opis roli.

    1.3 Kliknij Dodaj uprawnienia.

    1.4 Wybierz uprawnienia, które chcesz uwzględnić w roli, i kliknij Dodaj uprawnienia. 

    1.5 Użyj menu rozwijanych Wszystkie usługi i Wszystkie typy, aby filtrować i wybierać uprawnienia według usług i typów.

### 2.Tworzenie niestandardowej roli na podstawie istniejącej roli
    1.1 Wybierz role, na których chcesz oprzeć nową rolę niestandardową.
    
    1.2 Kliknij opcję Utwórz rolę z wyboru.
    
    1.3 Wprowadź nazwę, tytuł i opis roli.
    
    1.4 Odznacz uprawnienia, które chcesz wykluczyć z roli.
    
    1.5 Kliknij Dodaj uprawnienia, aby dołączyć wszelkie uprawnienia.
    
    1.6 Kliknij Utwórz.

### 3. Utwórz rolę niestandardową z CLI na podstawie pliku YAML i za pomocą komędy
x
```bash
# Utwórz plik role.yml
title: "Role Viewer"
description: "My custom role description."
stage: "ALPHA"
includedPermissions:
- iam.roles.get
- iam.roles.list

#Tworzenie roli na podstawie pliku
gcloud iam roles create [role-id] \
--project my-project-id \
--file my-role-definition.yaml

#Opisz naszą nową rolę za pomocą polecenia:
gcloud iam roles describe [role-id] \
--project [my-project-id]

#Pokaż wszystkie role
gcloud iam roles list


#Wyświetl lisę ról niestandardowych
gcloud iam roles list --project [PROJECT_ID]

#Aby wyświetlić listę usuniętych ról, możesz również określić 
    --show-deletedflagę.

#Update roli po naniesionych zmianach w pliku .yml
gcloud iam roles update [ROLE_ID] \
--project [PROJECT_ID] \
--file new-role-definition.yaml

#Update roli za pomocą polecenia
cloud iam roles update [ROLE_ID] \
--project [PROJECT_ID] \
--add-permissions storage.buckets.get,storage.buckets.list

#Wyłączanie roli
gcloud iam roles update [ROLE_ID] \
--project [PROJECT_ID] \
--stage DISABLED

#Usuwanie roli niestandardowej
gcloud iam roles delete [ROLE_ID] \
--project [PROJECT_ID]

#Cofanie usunięcia roli niestandardowej
gcloud iam roles undelete [ROLE_ID] \
--project [PROJECT_ID]
```