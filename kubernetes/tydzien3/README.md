
## [Podstawy kontenerów - kontynuacja](https://szkolachmury.pl/kubernetes/tydzien-3-podstawy-kontenerow-2/)

* [Dockerfile](https://docs.docker.com/engine/reference/builder/)
[Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
[Docker Compose](https://docs.docker.com/compose/)
[Docker Hub Nginx](https://hub.docker.com/_/nginx)
[Mulit-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/)

### 1. Operacje na obrazach oraz kontenerach

```bash
# Uruchamianie kontenera w trybie interaktywnym
docker run -it -p 8081:80 nginx /bin/bash

# Uruchamiam kontenre w trybie detached - czyli w tle
docker run -itd -p 8081:80 nginx /bin/bash

# Utworzenie commita z imege do nowego immage
docker commit <IMAGE_ID> <new-image_name>
```