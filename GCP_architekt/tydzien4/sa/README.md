# [Tworzenie Service Accunt przy użyciu konsoli GCP i CLI](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/service-accounts-hands-on/)

### 1. Tworzenie Service Accunt
    1.1 Otwórz w lewym menu IAM & Admin i otwórz Service Accounts.
    
    1.2 Kliknij opcję Utwórz konto usługi.
    
    1.3 Wprowadź nazwę konta usługi (przyjazną nazwę wyświetlaną), 
    opcjonalny opis, wybierz rolę, którą chcesz nadać kontu usługi, a następnie kliknij przycisk Zapisz.
    
    1.4 Tworzenie kluczy
    
        1.4.1 Poszukaj konta usługi, dla którego chcesz utworzyć klucz, kliknij przycisk Więcej w tym wierszu, a następnie kliknij opcję Utwórz klucz.
    
        1.4.2 Wybierz typ klucza i kliknij Utwórz.



### 2. Tworzenie Service Accunt za pomocą CLI
```bash
#Tworzenie Service Accunt
gcloud iam service-accounts create [SA-NAME] \
--description "[SA-DESCRIPTION]" \
--display-name "[SA-DISPLAY-NAME]"

#Listowanie Service Accunt
gcloud iam service-accounts list

#Tworzenie kluczy 
gcloud iam service-accounts keys create [/path/to/key_name.json] \
--iam-account [SA-NAME]@[PROJECT-ID].iam.gserviceaccount.com
```