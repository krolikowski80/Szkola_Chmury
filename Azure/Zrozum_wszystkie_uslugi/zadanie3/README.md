# [Zadanie nr 3 - Networking](https://szkolachmury.pl/microsoft-azure-zrozum-wszystkie-uslugi/tydzien-3-networking/lekcja-12-praca-domowa/)

> Zadanie polega na utworzeniu w maszyn/kontenerów i rozłożeniu ruchu z zewnątrz w zalwżności od ich dostępności. Jeżeli Trafic Manager odnotuje ewarię VM1 automatycznie przekieruje cały ruch na VM2. 
Ja wykonam to zadanie stawiająć 2 sieci wirtualne i w pierwszej 3 VM a przed nimi Load Balancer. W drugiej już tylko 1 VM.
Trafic Manager będzie przenesił ruch na sieć GRUPA-2 w przypadku awarii całej GRUPA-1
Wykonam to zadanie przy pomocy tego [tego](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-cli?tabs=option-1-create-load-balancer-standard), oraz [tego dokumentu](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview).
 
 ### Więcej dokumentacji:
  * [Azure VMs : Availability Sets and Availability Zones](https://social.technet.microsoft.com/wiki/contents/articles/51828.azure-vms-availability-sets-and-availability-zones.aspx)
  * [Availability options for virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/availability)
  * [Zarządzanie dostępnością maszyn wirtualnych z systemem Linux](https://docs.microsoft.com/pl-pl/azure/virtual-machines/manage-availability)


## 1. Tworzę grupy i sieci
```bash
# lista regionów
# https://docs.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest#az_account_list
az account list-locations -o table

# Zmienne
export myResourceGroup1=zadanienr3usa
export usa=centralus

export VNetName=myVNet
export VNetPref=10.1.0.0/16
export subnetName=myBackendSubnet
export subnetPref=10.1.0.0/24

export nsg=myNSG
export nsgRule=myNSGRuleHTTP

# Resource grpup
# https://docs.microsoft.com/en-us/cli/azure/ad/group?
az group create \
view=azure-cli-latest
--name $myResourceGroup1 \
--location $usa

# virtual network
# https://docs.microsoft.com/en-us/cli/azure/network/vnet?view=azure-cli-latest
az network vnet create \
--resource-group $myResourceGroup1 \
--location $usa \
--name $VNetName \
--address-prefixes $VNetPref \
--subnet-name $subnetName \
--subnet-prefixes $subnetPref

# Tworzę public IP address dla Bastion Host
# https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest#az-network-public-ip-create
az network public-ip create \
--resource-group $myResourceGroup1 \
--name $BasIP \
--sku Standard

# bastion subnet
az network vnet subnet create \
--resource-group $myResourceGroup1 \
--name $BastSubnet \
--vnet-name $VNetName \
--address-prefixes $BasPref

# Torzę bastion host
# https://azure.microsoft.com/pl-pl/services/azure-bastion/
# https://docs.microsoft.com/en-us/cli/azure/network/bastion?view=azure-cli-latest
az network bastion create \
--resource-group $myResourceGroup1 \
--name $BasName \
--public-ip-address $BasIP \
--vnet-name $VNetName \
--location $usa

# Tworzę Network Security Group
# https://docs.microsoft.com/en-us/cli/azure/network/nsg?view=azure-cli-latest
az network nsg create \
--resource-group $myResourceGroup1 \
--name $nsg

#Zasady dla NSG: Pezepuszczamy wszystkie protokoły (*), ruch wejściowy (czyli i wyjściowy) przychodzący od wszystkich (*), idący do wszystkich (*), na port 80 z priorytetem 200
#Wszytkie interfejsy sieciowe moich VM muszą należeć do tej NSG 

#https://docs.microsoft.com/en-us/cli/azure/network/nsg/rule?view=azure-cli-latest

az network nsg rule create \
--resource-group $myResourceGroup1 \
--nsg-name $nsg \
--name $nsgRule \
--protocol '*' \
--direction inbound \
--source-address-prefix '*' \
--source-port-range '*' \
--destination-address-prefix '*' \
--destination-port-range 80 \
--access allow \
--priority 200
```

## 2. Gupa maszyn i interfejsów
```bash
#zmienne
export nic1=myNicVM1
export nic2=myNicVM2
export nic3=myNicVM3

export vm1=myVM1
export vm2=myVM2
export vm3=myVM3

export avset=myAvSet

#Tworzę 3 interfejsy sieciowe dla moich VMek i umieszczam je w mojej VNET-subnet i NSG

#https://docs.microsoft.com/en-us/cli/azure/network/nic?view=azure-cli-latest

array=($nic1 $nic2 $nic3)
for vmnic in "${array[@]}"
do
  az network nic create \
  --resource-group $myResourceGroup1\
  --name $vmnic \
  --vnet-name $VNetName \
  --subnet $subnetName \
  --network-security-group $nsg
done

#Tworzę availability set dla VMek 
# https://docs.microsoft.com/pl-pl/azure/virtual-machines/manage-availability)
az vm availability-set create \
--name $avset \
--resource-group $myResourceGroup1 \
--location $usa 

# Tworzę Virtualne maszyny i podłączam je do interface
# Wiem, że to mega hakierski sposób na podawanie hasła. Ale to nie lekcja o security ;>
# Dla ułatwienai wszystkie maszyny mają takie samo login i pass

# https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_create

#VM1
az vm create \
--resource-group $myResourceGroup1 \
--name $vm1 \
--nics $nic1 \
--image centos \
--admin-username $azureuser \
--admin-password $azurepass \
--availability-set $avset \
--no-wait

# VM2
az vm create \
--resource-group $myResourceGroup1 \
--name $vm2 \
--nics $nic2 \
--image centos \
--admin-username $azureuser \
--admin-password $azurepass \
--availability-set $avset \
--no-wait

# VM3
az vm create \
--resource-group $myResourceGroup1 \
--name $vm3 \
--nics $nic3 \
--image centos \
--admin-username $azureuser \
--admin-password $azurepass \
--availability-set $avset \
--no-wait
```
## 3. Docker, Nginx i prosta strona www
> Na każdej z maszyn instauję dockera zgodnie z:
https://docs.docker.com/engine/install/centos/
oraz:
https://docs.docker.com/engine/install/linux-postinstall/


```bash
#Po zalogowaniu - Do tego potrzebny był mi bastion host
# Tworzę prostą strone index.html
# Tworzę prosty dockerfile
docker login
docker build -t webserver .
docker run -it --rm -d -p 8080:80 --name web webserver

#Czynność powtarzam na VM2 i VM3
```
## 4. Load Balancer
```bash
# Zmienne
export publicIP=myPublicIP
export LBname=myLoadBalancer
export FrontendIPname=myFrontEnd
export backendPoolName=myBackEndPool
export HlProbe=myHealthProbe
export HTTlbRule=myHTTPRule

#Aby uzyskać dostęp do swojej aplikacji internetowej w Internecie, potrzebujesz publicznego adresu IP dla Load Balncera
az network public-ip create \
--resource-group $myResourceGroup1 \
--name $publicIP \
--sku Basic

# Tworzę load balancer
# https://docs.microsoft.com/en-us/cli/azure/network/lb?view=azure-cli-latest
az network lb create \
--resource-group $myResourceGroup1 \
--name $LBname \
--sku Basic \
--public-ip-address $publicIP \
--frontend-ip-name $FrontendIPname \
--backend-pool-name $backendPoolName

# health probe na TCP i porcie 80 
# https://docs.microsoft.com/en-us/cli/azure/network/lb/probe?view=azure-cli-latest
az network lb probe create \
--resource-group $myResourceGroup1 \
--lb-name $LBname \
--name $HlProbe \
--protocol tcp \
--port 80

# Reguły równoważenia obciążenia: 
    * Nasłuchiwanie na porcie 80 w puli frontendu myFrontEnd. 
    * Wysyłanie ruchu sieciowego o zrównoważonym obciążeniu do puli adresów backendu myBackEndPool przy użyciu portu 80. 
    * Korzystanie z health probe myHealthProbe. 
    * Protokół TCP. Limit czasu bezczynności 15 minut.
# https://docs.microsoft.com/en-us/cli/azure/network/lb/rule?view=azure-cli-latest#az-network-lb-rule-create
az network lb rule create \
--resource-group $myResourceGroup1 \
--lb-name $LBname \
--name $HTTlbRule \
--protocol tcp \
--frontend-port 80 \
--backend-port 80 \
--frontend-ip-name $FrontendIPname \
--backend-pool-name $backendPoolName \
--probe-name $HlProbe \
--idle-timeout 15

# Dodaj maszyny wirtualne do load balancer backend pool
# Czyli dodaję wszystkie NIC
# https://docs.microsoft.com/en-us/cli/azure/network/nic/ip-config/address-pool?view=azure-cli-latest#az-network-nic-ip-config-address-pool-add
array=($nic1 $nic2 $nic3)
for vmnic in "${array[@]}"
do
az network nic ip-config address-pool add \
--address-pool $backendPoolName \
--ip-config-name $ipconfig \
--nic-name $vmnic \
--resource-group $myResourceGroup1 \
--lb-name $LBname
done

# I wielki test!!!
# https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest#az-network-public-ip-show
az network public-ip show \
--resource-group $myResourceGroup1 \
--name $publicIP \
--query ipAddress \
--output tsv

### Działa aż miło ;)
```
## 5. Druga - Awaryjna podcsieć
