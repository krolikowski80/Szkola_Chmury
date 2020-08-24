
## [Składowanie danych w kontenerach (Volume Containers)](https://szkolachmury.pl/kubernetes/tydzien-3-podstawy-kontenerow-2/skladowanie-danych-w-kontenerach-volume-containers/)
### 1. Volume
#### 1.1. Tworzenie volumenu
```bash
docker volume create <Volumen_Name>
docker volume ls
docker volume inspect <Volumen_Name> 
```

#### 1.2. Montowanie volumenu podczas tworzenia kontenera
```bash
docker run <-Flags> \
    --mount type=volume,source=<Volumen_Name>,target=<Path/To/Mount>\
    --name <Cont_Name> <Image_Name>
```

### 2. Bind mounts
#### 2.1. Montowanie katalogu podczas tworzenia kontenera
```bash
docker run <-Flags> \
    --mount type=bind,source=<Path/To/File>,target=<Path/To/Mount>\
    --name <Cont_Name> <Image_Name>
```