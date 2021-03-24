---
lab:
    title: 'Implement Monitoring'
    module: ' Monitoring'
---

# [Lab - Implement Monitoring](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_11-Implement_Monitoring.md)

## Exercise 1
### Provision the lab environment


```powershell
# var
$location = 'westeurope'
$rgName = 'az104-11-rg0'

# create the resource group
New-AzResourceGroup -Name $rgName -Location $location

# create the first virtual network and deploy a virtual machine into it by using the template

New-AzResourceGroupDeployment `
-ResourceGroupName $rgName `
-TemplateFile $HOME/az104-11-vm-template.json `
-TemplateParameterFile $HOME/az104-11-vm-parameters.json `
-AsJob
```