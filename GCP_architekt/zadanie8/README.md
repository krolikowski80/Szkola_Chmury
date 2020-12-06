# [Zadanie nr 8 - App Engine](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-8-app-engine/zadanie-domowe-nr-8/)


## Zad 1. Uruchamiasz aplikację w Google App Engine, która obsługuje ruch produkcyjny. Chcesz wdrożyć ryzykowną, ale konieczną zmianę w aplikacji. Może ona zniszczyć Twoją usługę, jeśli nie będzie prawidłowo zakodowana. Podczas tworzenia aplikacji zdajesz sobie sprawę, że możesz ją prawidłowo przetestować tylko z rzeczywistym ruchem użytkowników.

## 1. Środowiski pracy
```bash
#Plikk gcloudignore
echo "README.md" > .gcloudignore
echo .python-version >> .gcloudignore

#Virtualenv tworzę
pyenv virtualenv 3.8.5 zadanie8

#Virtualenv ustawiam
pyenv local zadanie8

#Instaluję pakiety
pip install flask
```
#2. Pliki aplikacji

<details>
  <summary><b><i>Plik main.py</i></b></summary>

```bash
#main.py  - hello world we flasku
from flask import Flask
app = Flask(__name__)


@app.route("/")
def greetings():
    return "Witamy w zadaniu nr 8"


if __name__ == "__main__":
    app.run(port=8080, debug=True)

```

</details>

##### [app.yaml Configuration File](https://cloud.google.com/appengine/docs/standard/python3/config/appref)

<details>
  <summary><b><i>Plik app.yaml</i></b></summary>

```bash
#app.yaml
service: zadnie8
runtime: python38
```
</details>

# 3 Wdrożenie i update
```bash
#Wdrożenie pierwszej wersji
gcloud app deploy --version zadanie8-v1

#Test pierwszej wersji
gcloud app browse -s zadanie8

#Wdrożenie drugiej wersji aplikacji
gcloud app deploy --version zadanie8-v2 --no-promote

#Dzielenie ruchu na wiele wersji
gcloud app services set-traffic zadanie8 \
--splits zadanie8-v1=.5,zadanie8-v2=.5
```

## Zad 2. Zarząd pewnej firmy zdecydował się na przeniesienie swojej aplikacji do środowiska w Google Cloud. Zdecydowali się umieścić swoją aplikacje na środowisku w App Engine. Środowisko wymaga integracji z bazą danych MySQL z których aplikacja pobiera dane.

```bash
#zmienne
echo "export project_id=$(gcloud info --format='value(config.project)')" > .var
echo "export instance_name=zad8inst" >> .var
echo "export root_pass=tajnehaslo12345" >> .var


#Utworzenie instancję MySQL
gcloud sql instances create $instance_name \
--activation-policy=ALWAYS \
--tier=db-n1-standard-1 \
--region=europe-west1

#Ustawiam hasło roota
gcloud sql users set-password root \
--host=% \
--instance $instance_name \
--password $root_pass

```
### [Inataluję i uruchamiam CloudSQL Proxy](https://cloud.google.com/sql/docs/mysql-connect-proxy)
```bash
#zmienne
echo "export sa_name=zad8sa" >> .var

#Tworzenie Service Account
gcloud iam service-accounts create $sa_name \
--display-name $sa_name

#Pobieram email konta
echo "export sa_email=$(gcloud iam service-accounts list \
--filter="displayName:$sa_name" \
--format='value(email)')" >> .var

#Przydzielanie roli do Service Account - ? NIE MOŻNA W JEDNYM POLECCENIU?
gcloud projects add-iam-policy-binding $project_id \
--member serviceAccount:$sa_email \
--role roles/cloudsql.admin

gcloud projects add-iam-policy-binding $project_id \
--member serviceAccount:$sa_email \
--role roles/cloudsql.client

gcloud projects add-iam-policy-binding $project_id \
--member serviceAccount:$sa_email \
--role roles/cloudsql.editor

#path do keya
echo "export keypath=/home/${USER}/Documents/key.json" >> .var

#Tworzenie kluczy 
gcloud iam service-accounts keys create $keypath \
--iam-account $sa_email

#Pobieram klienta proxy i nadaję mu uprawnienia
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy

#Pobieram connectionName
gcloud beta sql instances describe $instance_name | grep connectionName

#connectionName: szkola-chmury-tk:europe-west1:zad8inst
echo "export connectionName=szkola-chmury-tk:europe-west1:zad8inst" >> .var

#Uruchamioam proxy
sudo mkdir /cloudsql; sudo chmod 777 /cloudsql

./cloud_sql_proxy -instances=$connectionName=tcp:3306 \
-credential_file=$keypath &

#Utwórz bazę danych
mysql -h 127.0.0.1 -u root -p -e "CREATE DATABASE baza_zadanie;"
mysql -h 127.0.0.1 -u root -p

#Wynik
  ...
  Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
  ...
  mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| baza_zadanie       |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.23 sec)

```
> Wszytko działa, przystępuję do wdrożenia

### Wdrożenie aplikacji

```bash 
# Pobranie plików og gógla
wget https://github.com/GoogleCloudPlatform/php-docs-samples/archive/master.zip

#composer -> w katalogu projektu
composer install

# Zmiany w app.yaml dla USER, PASSWORD, DATABASE i CONNECTION_NAME



# Połącenie nastąpi (o ile nastąpi ;> ) po TCP

```