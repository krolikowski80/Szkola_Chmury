# [Zadanie nr 2](https://szkolachmury.pl/microsoft-azure-zrozum-wszystkie-uslugi/tydzien-2-compute-containers/lekcja-11-praca-domowa/)

> Zadanie polega na pobraniu [obrazu](https://hub.docker.com/r/pengbai/docker-supermario/) z Docher Hub i umieszczenie go w Azure Container Registry.
Następnie uruchomienie go i wystawienie aplikacji on public używając do tego:
 - Virual Machine
 - Azure Container Instance
 - Kubernetes (wkrótce)

## Krok 1 - Pobranie obrazu z DH i umieszczenie w ACR 
```bash
#Zmienne AZ
export myResourceGroup=krolik
export locateResourceGroup=uksouth
export containerRegistryName=szkolachmurykrolikowski
export registryPassword=mojeTajneHasloKtoreTutajZmienilem
export userName=szkolachmurykrolikowski


#Tworzę swoje prywatne repo na ACR
az acr create --resource-group $myResourceGroup \
--name $containerRegistryName \
--sku Basic

#Włączam konto administratora rejestru
az acr update -n $containerRegistryName \
--admin-enabled true

#Pobieram nazwę użytkownika i hasło do konta administratora
az acr credential show \
--name $containerRegistryName

#Loguje się do rejestru
az acr login \
--name $containerRegistryName \
-u $userName -p $registryPassword #To nie jest konieczne - jestem zalogowany do intefejsu Azure CLI
    
# WARNING! Your password will be stored unencrypted in /home/tomasz/.docker/config.json.
# Configure a credential helper to remove this warning. See
# https://docs.docker.com/engine/reference/commandline/login/#credentials-store
# WARTO O TYM POMYŚLEĆ!!!

#Pobieram obraz lokalnie
docker pull pengbai/docker-supermario

#Taguję obraz <registry-name>.azurecr.io
docker tag pengbai/docker-supermario:latest $containerRegistryName.azurecr.io/supermario:v1

#Wypycham mój obraz do ACR
docker push $containerRegistryName.azurecr.io/supermario:v1

#Lista obrazów na ACR
az acr repository list \
--name $containerRegistryName \
--output table
```

## Krok 2 Uruchamianie i wystawianie aplikacji

### 2.1 Virtual Machine

```bash
#Zmienne
export containerName=mariocont
export dnsLabel=mariodns
export myVM=krolikowskivm
export azureuser=krolik

#Lista dostępnych obrazów
az vm image list --output table

#Tworzę VM 
az vm create \
--resource-group $myResourceGroup \
--name $myVM \
--image Debian \
--admin-username $azureuser \
--generate-ssh-keys

#Otwieram port 8080
az vm open-port \
--port 8600 \ #Tak będę mapował porty 8600:8080
--resource-group $myResourceGroup \
--name $myVM

#Loguję się na VM
ssh $azureuser@51.105.42.126

#Instaluję docker zgodnie z https://docs.docker.com/engine/install/debian/
#oraz https://docs.docker.com/engine/install/linux-postinstall/

#Loguje się do rejestru -- A można zalogować się przez docker login ??
az acr login \
--name $containerRegistryName \
-u $userName -p $registryPassword #Tu już muszę podać login i hasło

#Pobieram i odpalam obraz 
docker pull szkolachmurykrolikowski.azurecr.io/supermario:v1

#Odpalam kontener
#Flagi:
# --name umożliwia nazwanie kontenera - zamiast losowej nazwy
# -p instruuje Docker, aby zamapował port 8600 hosta na port kontenera 8080
# -d starruje w trybie detached - czyli w tle
docker run -d -p 8600:8080 --name mario-app szkolachmurykrolikowski.azurecr.io/supermario:v1

#Czyszczenie zasobów
az vm delete \
--name $myVM \
--resource-group $myResourceGroup
```
### 2.2 Azure Container Instances
```bash
#tworzę pojedynczy kontener
az container create \
--resource-group $myResourceGroup \
--name $containerName \
--image $containerRegistryName.azurecr.io/supermario:v1 \
--ports 8080 \
--dns-name-label $dnsLabel \
--location $locateResourceGroup #taka sama jak resource grupy
--registry-username $userName \
--registry-password $registryPassword

#Czyszczenie zasobów
az container delete \
--resource-group $myResourceGroup \
--name $containerName
```
> Jak widać 2 metoda jest szybsza i przyjemniejsza.

## 2.3 Kubernetes
### Wkrótce