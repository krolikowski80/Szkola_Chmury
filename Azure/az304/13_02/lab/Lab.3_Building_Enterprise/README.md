# AZ-304 T3-Lab.3 Building Enterprise

### 1. Create an Event Hub namespace

```bash
# Zmienne
export myResourceGroup=lab3-zjazd3-rg
export location=westeurope

# Respurce group
az group create \
-n $myResourceGroup \
-l $location
```

<details>
  <summary><b><i>Deployment json dla EventHUB z consumergroup</i></b></summary>


```json


```
</details>

```bash
# Deployment ARM NameSpape i EventHUB
az deployment group create \
--resource-group $myResourceGroup \
--template-file template.json

```
> SAS Zrobiony w portalu. Na chwilę obecną nie umiem go zrobić po hakersku.

### 2 Create Docker Image
```bash
# Zmienne
export containerRegistryName=lab3zjazd3acr

# Pobieram pliki
wget https://github.com/cloudstateu/AZ304/raw/main/Lab3/ContainerApp.zip \
&& unzip ContainerApp.zip \
&& cd ContainerApp \
&& code .

# Create ACR - tak mi jakoś było szybciej
az acr create --resource-group $myResourceGroup \
--name $containerRegistryName \
--sku Basic \
--admin-enabled true

# Kompilowanie i wypychanie obrazu z pliku dockerfile (w Azure CloudShell)
az acr build --image containerapp \
  --registry lab3zjazd3acr \
  --file Dockerfile .

```

### 3 Create ACI

<details>
  <summary><b><i>Deployment json dla ACI </i></b></summary>

```json


```

</details>

<br>

<details>
  <summary><b><i>Oraz paramsy dla ACI </i></b></summary>

```json


```
</details>

<br>

```bash
# Deployment 
az deployment group create \
--resource-group $myResourceGroup \
--template-file template.json
```

### 4 Create Service Bus with 3 topics
