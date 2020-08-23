
## [Sieć w kontenerach ](https://szkolachmury.pl/kubernetes/tydzien-3-podstawy-kontenerow-2/siec-w-kontenerach/)

```bash
# Pokaż wszytkie sieci
docker network ls
```

```bash
# Tworzenie nowej sieci
# Utworzona w ten sposób urzywa drivera typu bridge
docker network create frontendnet
docker network create  backendnet
```

```bash
# Tworzenie nowej sieci z subnetem i gatewayem
docker network create --subnet 10.2.0.0/24 --gateway 10.2.0.1 networkname
```

```bash
# Podgląd atrybutów sieci
docker network inspect frontendnet
```

```bash
# Tworzenie kontenera i podłączanie go do sieci 
docker run -it --name kont01 --network frontendnet alpine sh
docker run -it --name kont02 --network backendnet alpine sh
docker run -it --name kont03 --network backendnet alpine sh
```

```bash
# Podłączenie do sieci host
docker run -it --network host alpine sh
```

```bash
# Usuwamy nieużywane sieci
docker network prune
```

