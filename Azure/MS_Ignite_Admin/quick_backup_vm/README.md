# [Back up a virtual machine in Azure with the Azure CLI](https://docs.microsoft.com/en-us/azure/backup/quick-backup-vm-cli)


### 1. Create a Linux virtual machine with the Azure CLI
```bash
# var
mainResGroup=myResourceGroup
mainLocation=westeurope
vmName=krolikVM01

# Create a resource group
az group create --name $mainResGroup --location $mainLocation

# Create virtual machine
az vm create \
--resource-group $mainResGroup \
--name $vmName \
--image UbuntuLTS \
--admin-username krolik \
--admin-password TajneHaslo%12345
```

### Create a Recovery Services vault

```bash
# var
rsaName=myRecoveryServicesVault

# Create a Recovery Services vault 
az backup vault create --resource-group $mainResGroup \
--name $rsaName \
--location $mainLocation

# Set on georesdundant setting
az backup vault backup-properties set \
--name $rsaName  \
--resource-group $mainResGroup \
--backup-storage-redundancy GeoRedundant \
--cross-region-restore-flag True
```

### Enable backup for an Azure VM
```bash
# enable protection using default policy values
az backup protection enable-for-vm \
--resource-group $mainResGroup \
--vault-name $rsaName \
--vm $vmName \
--policy-name DefaultPolicy

# If the VM isn't in the same resource group as that of the vault, then myResourceGroup refers to the resource group where vault was created. Instead of VM name, provide the VM ID as indicated below.
az backup protection enable-for-vm \
--resource-group myResourceGroup \
--vault-name myRecoveryServicesVault \
--vm $(az vm show -g $mainResGroup -n $vmName --query id | tr -d '"') \
--policy-name DefaultPolicy
```

### Start a backup job
```bash
# backs up the VM
az backup protection backup-now \
--resource-group $mainResGroup \
--vault-name $rsaName \
--item-name $vmName \
--container-name $vmName \
--retain-until 10-04-2021

# --container-name is the name of your VM
# --item-name is the name of your VM
# --retain-until value should be set to the last available date, in UTC time format (dd-mm-yyyy), that you wish the recovery point to be available

#### backup management type required ????

# Monitor the backup job
az backup job list \
--resource-group $mainResGroup \
--vault-name $rsaName \
--output table

    Name                                  Operation        Status     Item Name    Backup Management Type    Start Time UTC                    Duration
    ------------------------------------  ---------------  ---------  -----------  ------------------------  --------------------------------  --------------
    6cb9ce9c-d21e-4bbc-9446-8325f0a7e136  ConfigureBackup  Completed  krolikvm01   AzureIaasVM               2021-03-29T19:51:19.077077+00:00  0:01:31.639704
```
### Clean up deployment
```bash
# Clean up
az backup protection disable \
--resource-group $mainResGroup \
--vault-name $rsaName \
--container-name $vmName \
--item-name $vmName \
--delete-backup-data true

az backup vault delete \
--resource-group $mainResGroup \
--name $rsaName \

az group delete --name $mainResGroup
```