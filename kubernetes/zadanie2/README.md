### Zadanie domowe nr2

### Część 1 - zatrzymanie i usunięcie starych  kontenerów

```bash
# sudo su -

# sprawdzam jakie mam obrazy dockerowe
root@lapek:/home/tomasz# docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              08393e824c32        17 hours ago        132MB
```

```bash
# usuwam istniejące obrazy
root@lapek:/home/tomasz# docker rmi 08393e824c32
Error response from daemon: conflict: unable to delete 08393e824c32 (cannot be forced) - image is being used by running container b45ebeffe163
```

```bash
# Podczas próby usunięcia obrazu Dockera pojawia się błąd
# "obraz jest używany przez uruchomiony kontener"
# Aby dowiedzieć się, który kontener używa obrazu używam polecenia:

root@lapek:/home/tomasz# docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS              NAMES
b45ebeffe163        nginx               "/docker-entrypoint.…"   4 minutes ago       Up 4 minutes        80/tcp             romantic_lehmann

# Jak widać na powyższym wyjściu, kontener Dockera "romantic_lehmann" używa mojego obrazu
```

```bash
# Najpierw muszę zatrzymać kontener "romantic_lehmann". Aby to zrobić, użyję poniższego polecenia:

root@lapek:/home/tomasz# docker stop b45ebeffe163
b45ebeffe163
```

```bash 
# Teraz mogę usunąć kontener
root@lapek:/home/tomasz# docker ps -a | grep Exit
b45ebeffe163        nginx               "/docker-entrypoint.…"   11 minutes ago      Exited (0) 2 minutes ago                       romantic_lehmann

root@lapek:/home/tomasz# docker container rm b45ebeffe163
b45ebeffe163
root@lapek:/home/tomasz# docker ps -a | grep Exit
root@lapek:/home/tomasz# 
```

```bssh
# teraz mogę usunąć obraz
root@lapek:/home/tomasz# docker rmi 08393e824c32
Untagged: nginx:latest
Untagged: nginx@sha256:36b74457bccb56fbf8b05f79c85569501b721d4db813b684391d63e02287c0b2
Deleted: sha256:08393e824c32d456ff69aec72c64d1ab63fecdad060ab0e8d3d42640fc3d64c5
Deleted: sha256:16ea6e7b0ecc56682daf0e01d89ffe04aeb702f67e572e94e574b1aa63d2e3d3
Deleted: sha256:d1c30fbca15bed39f9d6a613d05885ab2de964ed39c8ad3a7091c94aad935f1c
Deleted: sha256:e860d6c3bb27d4d057f6c5412b92afa0ae15664f6914eb460784e755c1a651e5
Deleted: sha256:0e6a092cd837c31fb9b85896c5849a2a02ba89131a531fa6ca8811d35bcf25ca
Deleted: sha256:d0f104dc0a1f9c744b65b23b3fd4d4d3236b4656e67f776fe13f8ad8423b955c
```

 ### Część 2 - instalacja i interakcja z kontenerem

 ```bash
# startuję kontener z obrazem nginx
# -t, --tty     Przydziela pseudo-TTY
# -d, --detach  Uruchom kontener w tle i wydrukuj identyfikator kontenera
root@lapek:/home/tomasz# docker run -t -d nginx /bin/bash
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
bf5952930446: Pull complete 
ba755a256dfe: Pull complete 
c57dd87d0b93: Pull complete 
d7fbf29df889: Pull complete 
1f1070938ccd: Pull complete 
Digest: sha256:36b74457bccb56fbf8b05f79c85569501b721d4db813b684391d63e02287c0b2
Status: Downloaded newer image for nginx:latest
331d77c167ca12a2b1b6a21c1d9743d72665441fc8bafb340f8aa07c334c6839
```

```bash
# sprawdzam jakie mam uruchomione kontenery
root@lapek:/home/tomasz# docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
331d77c167ca        nginx               "/docker-entrypoint.…"   17 minutes ago      Up 17 minutes       80/tcp              kind_elion
```

```bash
# podłączam się do kontenera
root@lapek:/home/tomasz# docker exec -t -i 331d77c167ca /bin/bash
root@331d77c167ca:/# ls
bin  boot  dev	docker-entrypoint.d  docker-entrypoint.sh  etc	home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@331d77c167ca:/# exit
exit
root@lapek:/home/tomasz#
```

```bash
# zatrzymuję i usuwam kontener i obraz.
# tym razem usunę obraz metodą FORCE - bez updrzedniego usuwania zastopowanego kontenera
root@lapek:/home/tomasz# docker stop 331d77c167ca
331d77c167ca
```

```bash
root@lapek:/home/tomasz# docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS               NAMES
331d77c167ca        nginx               "/docker-entrypoint.…"   21 minutes ago      Exited (0) 3 seconds ago                       kind_elion
```

```bash
root@lapek:/home/tomasz# docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              08393e824c32        18 hours ago        132MB
```

```bash
root@lapek:/home/tomasz# docker rmi 08393e824c32
Error response from daemon: conflict: unable to delete 08393e824c32 (must be forced) - image is being used by stopped container 331d77c167ca
```

```bash
root@lapek:/home/tomasz# docker rmi -f  08393e824c32
Untagged: nginx:latest
Untagged: nginx@sha256:36b74457bccb56fbf8b05f79c85569501b721d4db813b684391d63e02287c0b2
Deleted: sha256:08393e824c32d456ff69aec72c64d1ab63fecdad060ab0e8d3d42640fc3d64c5
```