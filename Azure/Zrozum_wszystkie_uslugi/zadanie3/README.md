# [Zadanie nr 3 -Networking](https://szkolachmury.pl/microsoft-azure-zrozum-wszystkie-uslugi/tydzien-3-networking/lekcja-12-praca-domowa/)

> Zadanie polega na utworzeniu w maszyn/kontenerów i rozłożeniu ruchu z zewnątrz w zalwżności od ich dostępności. Jeżeli Trafic Manager odnotuj eaearię VM1 automatycznie przekieruje cały ruch na VM2. 
Ja wykonam to zadanie stawiająć 2 sieci wirtualne i w każdej 2 VM a przed nimi Load Balancer.
Trafic Manager będzie przenesił ruch na sieć GRUPA-2 w przypadku awarii całej GRUPA-1


* Resource Group - zadanienr3usa
    * VNET USA
    * Trafic Manager
        * Load BAlancer
            * VM 1 i VM 2
                * Container z Apache TOMCAT na prcie 80
                * Tylko prywatne IP

* Resource Group - zadanienr3eur
    * VNET EUR zapasowy
        *VM 1 z 



## 1. Tworzę grupy i sieci
```bash
#lista regionów
az account list-locations -o table

# Zmienne
export myResourceGroup1=zadanienr3usa
export myResourceGroup2=zadanienr3eur
export eur=westeurope
export usa=centralus
export myVirtualNetwork1=vnetusa
export myVirtualNetwork2=vneteur

# Resource Group 1
az group create --name $myResourceGroup1 --location $usa

# Resource Group 2
az group create --name $myResourceGroup2 --location $eur

#Tworzę VNET w każdej RG z domyślym sbbnetem

#vntusa
az network vnet create \
--name $myVirtualNetwork1 \
--resource-group $myResourceGroup1 \
--subnet-name default

#vneteur
az network vnet create \
--name $myVirtualNetwork2 \
--resource-group $myResourceGroup2 \
--subnet-name default
```
## 2. Tworzę VM w swoich sieciach
```bash
#Dla ułatwienia wszędzie będzie ten sam user i hasło
#Nie potrafię utworzyć całej grupy instancji na podstawie szablonu - jak w GCP
az vm create \
--resource-group $myResourceGroup1 \
--name $myVM1 \
--image Debian \
--admin-username $user \
--admin-password $pass \
--location $usa

#Otwieram port 8080
az vm open-port \
--port 8080 \
--resource-group $myResourceGroup1 \
--name $myVM1
```
