## AZ-304 Laboratorium Networking Hub and Spoke
### Maszyna VM01
```bash
# Zmienne
export myResourceGroup=rg-hub-and-spot
export location=westeurope

export VNetName=vnet01
export VNetPref=10.1.0.0/24

export subnetName=default
export subnetPref=10.1.0.0/24

export VM01publicIP=vm01-ip

export nsg=vm01-nsg
export nsgRule=vm01-nsg-rule

# Grupa zasobów
az group create \
--name $myResourceGroup \
--location $location

# virtual network
# https://docs.microsoft.com/en-us/cli/azure/network/vnet?view=azure-cli-latest
az network vnet create \
--resource-group $myResourceGroup \
--location $location \
--name $VNetName \
--address-prefixes $VNetPref \
--subnet-name $subnetName \
--subnet-prefixes $subnetPref

# Tworzę public IP address
# https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest#az-network-public-ip-create
az network public-ip create \
--resource-group $myResourceGroup \
--name $VM01publicIP \
--sku Basic \
--location $location \
--allocation-method Dynamic

# Tworzę Network Security Group
# https://docs.microsoft.com/en-us/cli/azure/network/nsg?view=azure-cli-latest
az network nsg create \
--resource-group $myResourceGroup \
--location $location \
--name $nsg


# Zasady dla NSG: Przepuszczamy wszystkie protokoły (*), ruch wejściowy (czyli i wyjściowy) przychodzący od wszystkich (*), idący do wszystkich (*), na port każdy (*) z priorytetem 200
# https://docs.microsoft.com/en-us/cli/azure/network/nsg/rule?view=azure-cli-latest
az network nsg rule create \
--resource-group $myResourceGroup \
--nsg-name $nsg \
--name $nsgRule \
--protocol '*' \
--direction inbound \
--source-address-prefix '*' \
--source-port-range '*' \
--destination-address-prefix '*' \
--destination-port-range '*' \
--access allow \
--priority 200

# NIC
az network nic create \
--resource-group $myResourceGroup \
--location $location \
--name $vm01nic \
--vnet-name $VNetName \
--subnet $subnetName \
--network-security-group $nsg

# Zapomniałem o PublicIP
az network nic ip-config list --nic-name $vm01nic --resource-group $myResourceGroup --out table

# Update
az network nic ip-config update \
--name ipconfig1 \
--nic-name $vm01nic \
--resource-group $myResourceGroup \
--public-ip-address $VM01publicIP

# Tworzę VM
az vm create \
--resource-group $myResourceGroup \
--name $vmName \
--nics $vm01nic \
--location $location \
--image UbuntuLTS \
--admin-username $user \
--admin-password $passwd \
--no-wait

# Lista adresów VM
az vm list-ip-addresses \
--name $vmName \
--resource-group $myResourceGroup \
--out table

    VirtualMachine    PublicIPAddresses    PrivateIPAddresses
    ----------------  -------------------  --------------------
    vm01              104.46.44.91         10.1.0.4

# Logowanie na VM
ssh $user@104.46.44.91

krolik@vm01:~$ lsb_release -a

No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.5 LTS
Release:        18.04
Codename:       bionic

# Działa
```
### Maszyna VM02

#### Edytuję szablon pobrany ze wskazanego githuba
#### [Szablony](./apache_template)
```bash 
# I wdrażam
az deployment group create \
--resource-group $myResourceGroup \
--template-file azuredeploy.json \
--parameters azuredeploy.parameters.json

#Logownie na maszyne

ssh krolik@vm02-ip.westeurope.cloudapp.azure.com

krolik@vm02:~$ lsb_release  -a

No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.5 LTS
Release:	18.04
Codename:	bionic
```

### Firewall
```bash
# Zmienne
export FirewallName=myfirewall
export VNetFw=vnet-hub
export fwpip=fw-public-ip
export ipcName=fw-config

# Vnet dla firewall
az network vnet create \
--name $VNetFw \
--resource-group $myResourceGroup \
--location $location \
--address-prefix 192.168.0.0/16 \
--subnet-name AzureFirewallSubnet \
--subnet-prefix 192.168.0.0/16

# Tworzę Firewall
az network firewall create \
--name $FirewallName \
--resource-group $myResourceGroup \ 
--location $location

# Publiczny adres IP
az network public-ip create \
--name $fwpip \
--resource-group $myResourceGroup \
--location $location \
--allocation-method static \
--sku standard

# ip-config
az network firewall ip-config create \
--firewall-name $FirewallName \
--name $ipcName \
--public-ip-address $fwpip \
--resource-group $myResourceGroup \
--vnet-name $VNetFw

# Update firewalla
az network firewall update \
--name $FirewallName \
--resource-group $myResourceGroup
 
az network public-ip show \
--name $fwpip \
--resource-group $myResourceGroup \
--query "ipAddress" -o tsv

```
### Połączenie dwóch niezależnych sieci

```bash
# ID wszystkich VNETów
az network vnet list -o table

    Name      ResourceGroup    Location    NumSubnets    Prefixes        DnsServers    DDOSProtection    VMProtection
    --------  ---------------  ----------  ------------  --------------  ------------  ----------------  --------------
    vnet-hub  rg-hub-and-spot  westeurope  1             192.168.0.0/16                False             False
    vnet01    rg-hub-and-spot  westeurope  1             10.1.0.0/24                   False             False
    vnet02    rg-hub-and-spot  westeurope  1             10.2.0.0/16                   False             False

# Tworzę peering z VNET01 do Fiewall VNET
az network vnet peering create \
--name VNET01-to-HUB \
--resource-group $myResourceGroup \
--vnet-name vnet01 \
--remote-vnet vnet-hub \
--allow-vnet-access

# Tworzę peering z Fiewall VNET do VNET01 - Trzeba teorzyć w obie strony
az network vnet peering create \
--name HUB-to-VNET01 \
--resource-group $myResourceGroup \
--vnet-name vnet-hub \
--remote-vnet vnet01 \
--allow-vnet-access

# Tworzę peering z VNET02 do Fiewall VNET
az network vnet peering create \
--name VNET02-to-HUB \
--resource-group $myResourceGroup \
--vnet-name vnet02 \
--remote-vnet vnet-hub \
--allow-vnet-access

# Tworzę peering z Fiewall VNET do VNET02 - Trzeba teorzyć w obie strony
az network vnet peering create \
--name HUB-to-VNET02 \
--resource-group $myResourceGroup \
--vnet-name vnet-hub \
--remote-vnet vnet02 \
--allow-vnet-access

# Tworzenie tras
#Zmienne
export vnet01tohubroute=vnet01-to-hub-route
export vnet02tohubroute=vnet02-to-hub-route

# Dodaję tablice routingu z VNET01 to HUB
az network route-table create \
--name $vnet01tohubroute \
--resource-group $myResourceGroup \
--location $location

# Trasa statyczna
az network route-table route create \
--name vnet01-to-vnet02-route \
--resource-group $myResourceGroup \
--route-table-name $vnet01tohubroute \
--address-prefix 10.1.0.0/24  \
--next-hop-type VirtualAppliance \
--next-hop-ip-address 192.168.0.4

```

I tutaj stanąłem w miejscu. 
Jak zrobić routing? ;>
Ale itak robienie tego w ten sposób jest czasochłonne. 
Trzeba to zrobić w Azure Resource Manager.