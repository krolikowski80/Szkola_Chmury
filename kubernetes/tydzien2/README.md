
## [Podstawy kontenerów na przykładzie Docker](hhttps://szkolachmury.pl/kubernetes/podstawy-kontenerow-na-przykladzie-docker/)

* [Technologia](https://docs.docker.com/engine/docker-overview/)

* [Środowisko uruchomieniowe](https://docs.docker.com/engine/install/)

* [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/)

### 1. Pierwszy kontener

```bash
# Uruchomienie pierwszego kontenera
# wszystko z prawami roota (sudo su-)
docker run hello-world

# Pokazanie obecnie uruchomionych kontenerów
docker ps

# Pokazanie wszystkich kontenerów
docker ps -a

# zatrzymanie kontenera
docker stop

# Usuwanie kontenerów
docker rm <CONTAINER>
    --force , -f

# Sprawdzanie listy obrazów
docker images

# Usuwanie obrazu
docker rmi <IMAGE_ID>
    --force , -f

# Tworzenie obrazów dockerowych

```