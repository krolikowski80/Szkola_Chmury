# Zadanie nr3 - Docker Registry

```bash
# Utworzenie pliku dockerfile 

FROM alpine:3.12

RUN apk add --update nodejs nodejs-npm

ADD https://raw.githubusercontent.com/cloudstateu/containers-w3-homework/master/index.js .

ADD https://raw.githubusercontent.com/cloudstateu/containers-w3-homework/master/package.json .

RUN npm install

CMD ["node", "index.js"]
```

```bash
# budowanie image i wynik końcowy
[00:06][tomasz@lapek][~/my_repos/Szkola_Chmury/kubernetes/zadanie3] $ docker build -t 'krolikowski/my_alpine:v001' .
[00:07][tomasz@lapek][~/my_repos/Szkola_Chmury/kubernetes/zadanie3] $ docker images 
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
krolikowski/my_alpine       v001                6f70430b46aa        9 seconds ago       56.6MB
```

```bash
# test obrazu
[00:20][tomasz@lapek][~/my_repos/Szkola_Chmury/kubernetes/zadanie3] $ docker run krolikowski/my_alpine:v001 
Welcome to week 3 Kubernetes training by Szkoła Chmury :)
```

```bash
# wysyłanie image do mojego docker hub
docker login
docker push krolikowski/my_alpine:v001
```
