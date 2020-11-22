# [Wdrażanie aplikacji internetowej Python Flask w App Engine Flexible](https://www.qwiklabs.com/focuses/3339?parent=catalog)

## Środowisk
```bash
#Możesz wyświetlić nazwę aktywnego konta za pomocą tego polecenia:
gcloud auth list

#(Wynik)
Credentialed accounts:
 - <myaccount>@<mydomain>.com (active)

#(Przykładowe dane wyjściowe)
Credentialed accounts:
 - google1623327_student@qwiklabs.net

#Możesz wyświetlić identyfikator projektu za pomocą tego polecenia:
gcloud config list project

#(Wynik)
[core]
project = <project_ID>

#(Przykładowe dane wyjściowe)
[core]
project = qwiklabs-gcp-44776a13dea667a6

#Pobierz przykładowy kod
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

#Zmień katalog na python-docs-samples/codelabs/flex_and_vision:
cd python-docs-samples/codelabs/flex_and_vision

#Ustaw zmienną środowiskową dla [YOUR_PROJECT_ID], zastępując [YOUR_PROJECT_ID]ją własnym identyfikatorem projektu:
export PROJECT_ID=$(gcloud info --format='value(config.project)')

#Utwórz konto usługi, aby uzyskać dostęp do interfejsów API Google Cloud podczas testowania lokalnego:
gcloud iam service-accounts create qwiklab \
--display-name "My Qwiklab Service Account"

#Nadaj nowo utworzonemu kontu usługi odpowiednie uprawnienia:
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member serviceAccount:qwiklab@${PROJECT_ID}.iam.gserviceaccount.com \
--role roles/owner

#Po utworzeniu konta usługi utwórz klucz konta usługi:
gcloud iam service-accounts keys create ~/key.json \
--iam-account qwiklab@${PROJECT_ID}.iam.gserviceaccount.com
#To polecenie generuje klucz konta usługi przechowywany w pliku JSON o nazwie key.jsonw katalogu domowym.

#Korzystając z bezwzględnej ścieżki wygenerowanego klucza, ustaw zmienną środowiskową dla klucza konta usługi:
export GOOGLE_APPLICATION_CREDENTIALS="/home/${USER}/key.json"
```
##Lokalne testowanie aplikacji

```bash
#Robuę wirtualne środowisko
virtualenv -p python3 env

#aktywuj nowo utworzony virtualenv o nazwie env:
source env/bin/activate

#Użyj pip do zainstalowania zalpakietów dla projektu z pliku requirements.txt
pip install -r requirements.txt

#Następnie utwórz instancję App Engine za pomocą:
gcloud app create
#Monit wyświetli listę regionów. Wybierz region obsługujący App Engine Flexible for Python, a następnie naciśnij Enter . Możesz przeczytać więcej o regionach i strefach tutaj .

#Ustaw zmienną środowiskową CLOUD_STORAGE_BUCKET równą nazwie swojego PROJECT_ID . 
#( Dla wygody ogólnie zaleca się nadanie zasobnikowi takiej samej nazwy jak PROJECT_ID ).
export CLOUD_STORAGE_BUCKET=${PROJECT_ID}

# Tworzę zasobnik
gsutil mb gs://${PROJECT_ID}
```
## Uruchomienie aplikacji
```bash
#aby uruchomić aplikację:
python main.py
```
## Wdrażanie aplikacji w App Engine Flexible
```bash
#modyfikacja app.yaml
nano app.yaml

#Zaktualizuj swój limit czasu Cloud Build:
gcloud config set app/cloud_build_timeout 1000

#Wdróż swoją aplikację w App Engine przy użyciu gcloud:
gcloud app deploy
```