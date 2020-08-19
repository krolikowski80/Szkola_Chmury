
## [Podstawy kontenerów - kontynuacja](https://szkolachmury.pl/kubernetes/tydzien-3-podstawy-kontenerow-2/)

* [Dockerfile](https://docs.docker.com/engine/reference/builder)

* [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices)

* [Docker Compose](https://docs.docker.com/compose)

* [Docker Hub Nginx](https://hub.docker.com/_/nginx)

* [Mulit-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build)

### 1. Operacje na obrazach oraz kontenerach

```bash
# Uruchamianie kontenera w trybie interaktywnym
docker run -it -p 8081:80 nginx /bin/bash

# Uruchamiam kontenre w trybie detached - czyli w tle
docker run -itd -p 8081:80 nginx /bin/bash

# Utworzenie commita z imege do nowego immage
docker commit <IMAGE_ID> <new-image_name>

# Przeglądanie historii repozytorium
docker history <IMAGE_ID>

# Logowanie się do uruchomionego kontenera
docker exec -t -i <CONT_ID> /bin/bash

# Kopiowanie plikóe z hosta/kontenera do kontenera/hosta
docker cp 'nazwa_pliku' '<CONT_ID>:path/to/file.txt'

# Sprawdzanie zużycia zasobów przez kontener
docker stats <CONT_ID>

# Logi z kontenera na konsoli
docker logs <CONT_ID> -f

# Szczegółowe info o kontenerze/obrazie
docker inspect <CONT_ID>/<IMAGE_ID>

# Jakie zmiany nastąpiły w kontenerze od czasu jego uruchomienia
docker dif <CONT_ID>

# zmiana nazwy obrazu w lokalnym repo
docker tag old_name new_name

# Pobieranie obrazu bez uruchomienia
docker pull <IMAGE_NAME>

```