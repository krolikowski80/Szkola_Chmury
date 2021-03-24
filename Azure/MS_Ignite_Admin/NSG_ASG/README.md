# [Create and manage network security groups](https://docs.microsoft.com/en-us/learn/modules/secure-and-isolate-with-nsg-and-service-endpoints/3-exercise-network-security-groups)

### Create a virtual network and network security group
```bash
# Find the location name with the following command.
az account list-locations -o table

# Var
rg=vnet01lab
loc=westeurope
vnetName=ERP-servers
vnetPrefix=10.0.0.0/16
subAppName=Applications
subAppPrefix=10.0.0.0/24

subDataName=Databases
subDataPrefix=10.0.1.0/24

nsgName=ERP-SERVERS-NSG

# create the resource group
az group create --name $rg --location $loc 

# create the ERP-servers virtual network and the Applications subnet
az network vnet create \
--resource-group $rg \
--name $vnetName \
--address-prefix $vnetPrefix \
--subnet-name $subAppName \
--subnet-prefix $subAppPrefix

# create the Databases subnet
az network vnet subnet create \
--resource-group $rg \
--vnet-name $vnetName \
--address-prefix $subDataPrefix  \
--name $subDataName

# create the ERP-SERVERS-NSG network security group
az network nsg create \
--resource-group $rg \
--name $nsgName
```
### Create VMs running Ubuntu
```bash
# var
vmAppName=AppServer
vmDataName=DataServer
vmImg=UbuntuLTS
size=Standard_DS1_v2
username=azureuser
customData=cloud-init.yml
password=tajneHaslo%12345


# build the AppServer VM
wget -N https://raw.githubusercontent.com/MicrosoftDocs/mslearn-secure-and-isolate-with-nsg-and-service-endpoints/master/cloud-init.yml

az vm create \
--resource-group $rg \
--name $vmAppName \
--vnet-name $vnetName \
--subnet $subAppName \
--nsg $nsgName \
--image $vmImg \
--size $size \
--admin-username $username \
--custom-data cloud-init.yml \
--no-wait \
--admin-password $password

# build the DataServer VM
az vm create \
--resource-group $rg \
--name $vmDataName \
--vnet-name $vnetName \
--subnet $subDataName \
--nsg $nsgName \
--image $vmImg \
--size $size \
--admin-username $username \
--custom-data cloud-init.yml \
--admin-password $password

# To confirm that the VMs are running and list the IP addresses
az vm list \
--resource-group $rg \
--show-details \
--query "[*].{Name:name, Provisioned:provisioningState, Power:powerState, PrivateIP:privateIps, PublicIP:publicIps}" \
--output table
```

### Check default connectivity

```bash
# To make it easier to connect to your VMs during the rest of this exercise, assign the public IP addresses to variables.
APPSERVERIP="$(az vm list-ip-addresses \
--resource-group $rg \
--name  $vmAppName \
--query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
--output tsv)"

DATASERVERIP="$(az vm list-ip-addresses \
--resource-group $rg \
--name $vmDataName \
--query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
--output tsv)"

# test
ssh azureuser@$DATASERVERIP -o ConnectTimeout=5
ssh: connect to host 13.80.253.87 port 22: Connection timed out
```

### Create a security rule for SSH
```bash
az network nsg rule create \
--resource-group $rg \
--nsg-name $nsgName \
--name AllowSSHRule \
--direction Inbound \
--priority 100 \
--source-address-prefixes '*' \
--source-port-ranges '*' \
--destination-address-prefixes '*' \
--destination-port-ranges 22 \
--access Allow \
--protocol Tcp \
--description "Allow inbound SSH"

# create a new inbound security rule to deny HTTP access over port 80
az network nsg rule create \
--resource-group $rg \
--nsg-name $nsgName \
--name httpRule \
--direction Inbound \
--priority 150 \
--source-address-prefixes 10.0.1.4 \
--source-port-ranges '*' \
--destination-address-prefixes 10.0.0.4 \
--destination-port-ranges 80 \
--access Deny \
--protocol Tcp \
--description "Deny from DataServer to AppServer on port 80"

# Test HTTP connectivity between virtual machines
ssh -t azureuser@$APPSERVERIP 'wget http://10.0.1.4; exit; bash'
    
    Connecting to 10.0.1.4:80... connected.
    HTTP request sent, awaiting response... 200 OK

ssh -t azureuser@$DATASERVERIP 'wget http://10.0.0.4; exit; bash'

    Connecting to 10.0.0.4:80... Connection to 13.80.253.87 closed.
```

### Deploy an app security group

```bash
# var
asgName=ERP-DB-SERVERS-ASG

# create a new app security group
az network asg create \
--resource-group $rg \
--name $asgName

# associate DataServer with the app security group
az network nic ip-config update \
--resource-group $rg \
--application-security-groups $asgName \
--name $ipConfigDsName \
--nic-name $nicDsName \
--vnet-name $vnetName \
--subnet $subDataName

# update the HTTP rule in the ERP-SERVERS-NSG
az network nsg rule update \
--resource-group $rg \
--nsg-name $nsgName \
--name httpRule \
--direction Inbound \
--priority 150 \
--source-address-prefixes "" \
--source-port-ranges '*' \
--source-asgs ERP-DB-SERVERS-ASG \
--destination-address-prefixes 10.0.0.4 \
--destination-port-ranges 80 \
--access Deny \
--protocol Tcp \
--description "Deny from DataServer to AppServer on port 80 using application security group"

# Test
sh -t azureuser@$APPSERVERIP 'wget http://10.0.1.4; exit; bash'

    azureuser@13.80.244.69's password: 
    --2021-03-18 19:23:30--  http://10.0.1.4/
    Connecting to 10.0.1.4:80... connected.
    HTTP request sent, awaiting response... 200 OK

ssh -t azureuser@$DATASERVERIP 'wget http://10.0.0.4; exit; bash'

    azureuser@13.80.253.87's password: 
    --2021-03-18 19:23:42--  http://10.0.0.4/
    Connecting to 10.0.0.4:80... Connection to 13.80.253.87 closed.
```

### Cleaning resource
```bash
