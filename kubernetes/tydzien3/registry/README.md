
## [Rejestr dla kontenerów](https://szkolachmury.pl/kubernetes/tydzien-3-podstawy-kontenerow-2/rejestr-dla-kontenerow/)

```bash
# eksport kontenera do lokalnego systemu plików\
docker export <Kont_Name> -o </path/to/file/File_Name>
```

```bash
# import file i stworzenie obrazu dockera
docker import <File_Name> <My_Image_Name>
```

```bash
# Tagowanie własnego obrazu
docker tag <Repository_Name>:<TAG> <Repository_Name>:<NEW_TAG>
```

```bash
# wysyłanie zmian ro repozytorium
docker push <Repository_Name>:<TAG>
```