## [Wprowadzenie do platformy Docker](https://google.qwiklabs.com/focuses/1029?parent=catalog)

### Hello World

```bash
#Kontener Hello World
docker run hello-world

#Aby przyjrzeć się obrazowi kontenera, który został pobrany z Docker Hub
docker images

#Uruchomione kontenery
docker ps

#Aby zobaczyć wszystkie kontenery
docker ps -a
```
### Budowa

```bash
#Zbudujmy obraz platformy Docker oparty na prostej aplikacji 
mkdir test && cd test

#utworzyć aplikację
cat > app.js <<EOF
const http = require('http');

const hostname = '0.0.0.0';
const port = 80;

const server = http.createServer((req, res) => {
    res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
        res.end('Hello World\n');
});

server.listen(port, hostname, () => {
    console.log('Server running at http://%s:%s/', hostname, port);
});

process.on('SIGINT', function() {
    console.log('Caught interrupt signal and will exit');
    process.exit();
});
EOF

#zbudujmy obraz
#Zwróć uwagę ponownie na „.”, Co oznacza katalog bieżący, więc musisz uruchomić to polecenie z poziomu katalogu zawierającego plik Dockerfile
docker build -t node-app:0.1 .

#aby spojrzeć na utworzone obrazy
docker images
```
### Uruchamianie

```bash
#Uruchamianie kontenerów na podstawie zbudowanego obraz
#Flaga --name umożliwia nazwanie kontenera, jeśli chcesz. -p instruuje Docker, aby zamapował port 4000 hosta na port kontenera 80
docker run -p 4000:80 --name my-app node-app:0.1

#Zatrzymuję i usuwam kontener
docker stop my-app && docker rm my-app

#Uruchamianie kontenera w tle
docker run -p 4000:80 --name my-app -d node-app:0.1

#Uruchomione kontenery
docker ps

#logi kontenera
docker logs [container_id]
```

```bash
#Zmiany
cd test

#Edytuj plik app.js i zamień „Hello World” na:

const server = http.createServer((req, res) => {
    res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
        res.end('Welcome to Cloud\n');
});

#Zbuduj nowy obraz i otaguj go 0.2
docker build -t node-app:0.2 .

#Uruchom inny kontener z nową wersją obrazu. Zwróć uwagę, jak mapujemy port 8080 hosta zamiast 80. Nie możemy użyć portu 4000 hosta, ponieważ jest już używany
docker run -p 8080:80 --name my-app-2 -d node-app:0.2

#test
curl http://localhost:8080
Welcome to Cloud
```
### Debugowanie
```bash
#Przegląd logów kontenera
docker logs -f [container_id]

#Czasami będziesz chciał rozpocząć interaktywną sesję Bash w uruchomionym kontenerze. Możesz do tego użyć docker exec.
docker exec -it [container_id] bash

#metadane kontenera
docker inspect [container_id]
```

### Publikowanie
```bash
#Zmienne
[hostname]      = gcr.io 
[id-projektu]   = identyfikator Twojego projektu - gcloud config list project
[image]         = nazwa Twojego obrazu 
[tag]           = dowolny wybrany ciąg znaków. Jeśli nie jest określony, domyślnie jest to "latest".

#Oznacz aplikację węzła: 0.2. Zastąp [identyfikator projektu] swoją konfiguracją 
docker tag node-app:0.2 gcr.io/[project-id]/node-app:0.2

#Przekaż ten obraz do gcr.
docker push gcr.io/[project-id]/node-app:0.2

#Zatrzymaj i usuń wszystkie pojemniki:
docker stop $(docker ps -q)
docker rm $(docker ps -aq)

#Musisz usunąć obrazy podrzędne (z node:6) przed usunięciem obrazu node.
docker rmi node-app:0.2 gcr.io/[project-id]/node-app node-app:0.1
docker rmi node:6
docker rmi $(docker images -aq) # usuń pozostałe obrazy
docker images

#Pobierz obraz i uruchopm go
docker pull gcr.io/[project-id]/node-app:0.2
docker run -p 4000:80 -d gcr.io/[project-id]/node-app:0.2
curl http://localhost:4000
```