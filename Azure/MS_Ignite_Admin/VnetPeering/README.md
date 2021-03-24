# [Prepare virtual networks for peering by using Azure CLI commands](https://docs.microsoft.com/en-us/learn/modules/integrate-vnets-with-vnet-peering/3-exercise-prepare-vnets-for-peering-using-azure-cli-commands)

### Create the virtual networks
```bash
# create the virtual network and subnet for the Sales systems
az network vnet create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --name SalesVNet \
    --address-prefix 10.1.0.0/16 \
    --subnet-name Apps \
    --subnet-prefix 10.1.1.0/24 \
    --location northeurope

# create the virtual network and subnet for the Marketing systems
az network vnet create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --name MarketingVNet \
    --address-prefix 10.2.0.0/16 \
    --subnet-name Apps \
    --subnet-prefix 10.2.1.0/24 \
    --location northeurope

# create the virtual network and subnet for the Research systems
az network vnet create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --name ResearchVNet \
    --address-prefix 10.3.0.0/16 \
    --subnet-name Data \
    --subnet-prefix 10.3.1.0/24 \
    --location westeurope
```
### Confirm the virtual network configuration
```bash
# view the virtual networks
az network vnet list --output table
```
### Create virtual machines in each virtual network
```bash
# create an Ubuntu VM in the Apps subnet of SalesVNet
az vm create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --no-wait \
    --name SalesVM \
    --location northeurope \
    --vnet-name SalesVNet \
    --subnet Apps \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Password_d123

# create another Ubuntu VM in the Apps subnet of MarketingVNet. 
az vm create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --no-wait \
    --name MarketingVM \
    --location northeurope \
    --vnet-name MarketingVNet \
    --subnet Apps \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Password_d123

# create an Ubuntu VM in the Data subnet of ResearchVNet
az vm create \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --no-wait \
    --name ResearchVM \
    --location westeurope \
    --vnet-name ResearchVNet \
    --subnet Data \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Password_d123

# To confirm that the VMs are running, run the following command. This uses the Linux watch command which will refresh every five seconds.
watch -d -n 5 "az vm list \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --show-details \
    --query '[*].{Name:name, ProvisioningState:provisioningState, PowerState:powerState}' \
    --output table"
```
### Create virtual network peering connections
```bash
# create the peering connection between the SalesVNet and MarketingVNet virtual networks.
az network vnet peering create \
    --name SalesVNet-To-MarketingVNet \
    --remote-vnet MarketingVNet \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name SalesVNet \
    --allow-vnet-access

# create a reciprocal connection from MarketingVNet to SalesVNet.
az network vnet peering create \
    --name MarketingVNet-To-SalesVNet \
    --remote-vnet SalesVNet \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name MarketingVNet \
    --allow-vnet-access

# create the peering connection between the MarketingVNet and ResearchVNet virtual networks.
az network vnet peering create \
    --name MarketingVNet-To-ResearchVNet \
    --remote-vnet ResearchVNet \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name MarketingVNet \
    --allow-vnet-access

# create the reciprocal connection between ResearchVNet and MarketingVNet.
az network vnet peering create \
    --name ResearchVNet-To-MarketingVNet \
    --remote-vnet MarketingVNet \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name ResearchVNet \
    --allow-vnet-access
```

### Check the virtual network peering connections
```bash
# check the connection between SalesVNet and MarketingVNet.
az network vnet peering list \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name SalesVNet \
    --output table

# to check the peering connection between the ResearchVNet and MarketingVNet virtual networks
az network vnet peering list \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --vnet-name ResearchVNet \
    --output table
```
### Check effective routes
```bash
# to look at the routes that apply to the SalesVM network interface.
az network nic show-effective-route-table \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --name SalesVMVMNic \
    --output table

# Look at the routes for MarketingVM.
az network nic show-effective-route-table \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --name MarketingVMVMNic \
    --output table
```

### Verify virtual network peering by using SSH between Azure virtual machines
```bash
#  list the IP addresses you'll use to connect to the VMs
az vm list \
    --resource-group learn-d6049916-c335-46d3-9c92-a8f5f143fe7b \
    --query "[*].{Name:name, PrivateIP:privateIps, PublicIP:publicIps}" \
    --show-details \
    --output table
```
