### Zadanie domowe nr2

# sudo su -

```bash
# sprawdzam jakie mam obrazy dockerowe
root@lapek:/home/tomasz# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              8cf1bfb43ff5        13 days ago         132MB
```

```bash
# usuwam istniejące obrazy
root@lapek:/home/tomasz# docker rmi 8cf1bfb43ff5
Error response from daemon: conflict: unable to delete 8cf1bfb43ff5 (cannot be forced) - image is being used by running container 7521db463f86
root@lapek:/home/tomasz# 
```
# Podczas próby usunięcia obrazu Dockera pojawia się błąd
# "obraz jest używany przez uruchomiony kontener"

# Aby dowiedzieć się, który kontener używa obrazu używam polecenia:
```bash
root@lapek:/home/tomasz# docker ps -a
CONTAINER ID   IMAGE        COMMAND                  CREATED             STATUS                      PORTS               NAMES
7521db463f86   nginx        "/docker-entrypoint.…"   7 minutes ago       Up 7 minutes                80/tcp              sweet_hopper
094ffda01f0c   nginx        "/docker-entrypoint.…"   35 minutes ago      Exited (0) 16 minutes ago                       adoring_johnson
```



