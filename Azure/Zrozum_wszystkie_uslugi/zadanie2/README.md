# [Zadanie nr 2](https://szkolachmury.pl/microsoft-azure-zrozum-wszystkie-uslugi/tydzien-2-compute-containers/lekcja-11-praca-domowa/)

> Zadanie polega na pobraniu [obrazu](https://hub.docker.com/r/pengbai/docker-supermario/) z Docker Hub i umieszczenie go w Azure Container Registry.
Następnie uruchomienie go i wystawienie aplikacji on public używając do tego:
 - Virual Machine
 - Azure Container Instance
 - Kubernetes

## [Deploy and use Azure Container Registry](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr)
## [Deploy an Azure Kubernetes Service (AKS) cluster](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)

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
> Wszytsko zostało już usunięte, więc tworzę na nowo ACR, obraz itp...
```bash
#Zmienne
export newResourceGroup=zadnie2k8s
export region=northeurope
export klusterName=myAKSCluster
export containerRegistryName=szkolachmurykrolikowski
export registryPassword=

#Tworzę nowy Resource Group
# Resource grpup
# https://docs.microsoft.com/en-us/cli/azure/ad/group?
az group create \
--name $newResourceGroup \
--location $region

#Tworzę swoje prywatne repo na ACR
az acr create --resource-group $newResourceGroup \
--name $containerRegistryName \
--sku Basic

#Włączam konto administratora rejestru
az acr update -n $containerRegistryName \
--admin-enabled true

#Tworzę sobię VMkę bo samo przepychanie obrazów u mnie będzie trwało do rana
az vm create \
--resource-group $newResourceGroup \
--name $myVM \
--image Debian \
--admin-username $azureuser \
--generate-ssh-keys

# Loguję się tam
# Pobieram obraz
docker pull pengbai/docker-supermario

#Taguję obraz <registry-name>.azurecr.io
docker tag pengbai/docker-supermario:latest $containerRegistryName.azurecr.io/supermario:v1

#loguję się - nie mam az CLI - ale Dockerowe CLI też to obsługuje
docker login szkolachmurykrolikowski.azurecr.io -u szkolachmurykrolikowski

#Wypycham mój obraz do ACR
docker push $containerRegistryName.azurecr.io/supermario:v1
# I już VMka mi nie potrzebna

# Tworzę klaster Kubernetes
az aks create \
--resource-group $newResourceGroup \
--name $klusterName \
--node-count 2 \
--generate-ssh-keys \
--attach-acr $containerRegistryName
# Muiałem usunąć wszystkie zasoby VM, VNET, NIC bo wyleciałem na quitach
 Operation could not be completed as it results in exceeding approved Total Regional Cores quota. Additional details - Deployment Model: Resource Manager, Location: northeurope, Current Limit: 4, Current Usage: 1, Additional Required: 4, (Minimum) New Limit Required: 5.

#Co mam na ACR?
az acr repository list --name $containerRegistryName -o table
Result
----------
supermario

az acr repository show-tags --name $containerRegistryName --repository supermario --output table
Result
--------
v1

# Połączenie się z klastrem za pomocą kubectl
az aks get-credentials --resource-group $newResourceGroup --name $klusterName

#I co mam?
kubectl get nodes

    NAME                                STATUS   ROLES   AGE    VERSION
    aks-nodepool1-58657148-vmss000000   Ready    agent   6m4s   v1.18.10
    aks-nodepool1-58657148-vmss000001   Ready    agent   6m5s   v1.18.10

# Pobieram nzwy servera do logowania (I jest query ;>)
az acr list \
-g $newResourceGroup \
--query "[].{acrLoginServer:loginServer}" \
-o table

# Aktualizacja manifestu
containers:
- name: supermario
  image: szkolachmurykrolikowski.azurecr.io/supermario:v1

# Deployment
I tutaj narazie moja wiedza się kończy ;>


```