# var
$location = 'westeurope'
$rgName = 'az104-07-rg0'

# create the resource group
New-AzResourceGroup -Name $rgName -Location $location

# create the first virtual network and deploy a virtual machine into it by using the template
New-AzResourceGroupDeployment `
   -ResourceGroupName $rgName `
   -TemplateFile /home/tomasz/local_repo/Szkola_Chmury/Azure/MS_Ignite_Admin/storage/az104-07-vm-template.json `
   -TemplateParameterFile /home/tomasz/local_repo/Szkola_Chmury/Azure/MS_Ignite_Admin/storage/az104-07-vm-parameters.json `
   -AsJob