# [Exercise - Design and implement IP addressing for Azure virtual networks](https://docs.microsoft.com/en-us/learn/modules/design-ip-addressing-for-azure/5-exercise-implement-vnets?source=learn)

### Create the CoreServicesVnet virtual network
```bash
# create the CoreServicesVnet virtual network
az network vnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --name CoreServicesVnet \
    --address-prefix 10.20.0.0/16 \
    --location westus

# create the subnets that we need
az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name CoreServicesVnet \
    --name GatewaySubnet \
    --address-prefixes 10.20.0.0/27

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name CoreServicesVnet \
    --name SharedServicesSubnet \
    --address-prefixes 10.20.10.0/24

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name CoreServicesVnet \
    --name DatabaseSubnet \
    --address-prefixes 10.20.20.0/24

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name CoreServicesVnet \
    --name PublicWebServiceSubnet \
    --address-prefixes 10.20.30.0/24

# Let's take a look at what we have created.
az network vnet subnet list \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name CoreServicesVnet \
    --output table
```
### Create the ManufacturingVnet virtual network
```bash
# create the ManufacturingVnet
az network vnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --name ManufacturingVnet \
    --address-prefix 10.30.0.0/16 \
    --location northeurope

# create the subnets that we need
az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ManufacturingVnet \
    --name ManufacturingSystemSubnet \
    --address-prefixes 10.30.10.0/24

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet1 \
    --address-prefixes 10.30.20.0/24

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet2 \
    --address-prefixes 10.30.21.0/24

az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet3 \
    --address-prefixes 10.30.22.0/24

# take a look at what we have created
az network vnet subnet list \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ManufacturingVnet \
    --output table
```
### Create the ResearchVnet virtual network
```bash
# create the ResearchVnet
az network vnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --name ResearchVnet \
    --address-prefix 10.40.40.0/24 \
    --location westindia

# subnets that we need
az network vnet subnet create \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ResearchVnet \
    --name ResearchSystemSubnet \
    --address-prefixes 10.40.40.0/24

# Let's take a look at the final virtual network
az network vnet subnet list \
    --resource-group learn-8678f2a2-5a98-421b-bda8-f6d1828f565d \
    --vnet-name ResearchVnet \
    --output table
```
