# [Create an Azure virtual network](https://docs.microsoft.com/en-us/learn/modules/configure-network-for-azure-virtual-machines/3-exercise-create-azure-virtual-network)

```powershell
# Create a resource group
$Location = "westeurope"
$Name = "vm-ingnite1"
New-AzResourceGroup -Name $Name -Location $Location

# Create a subnet and virtual network
$Subnet = New-AzVirtualNetworkSubnetConfig -Name default -AddressPrefix 10.0.0.0/24
New-AzVirtualNetwork `
    -Name myVnet `
    -ResourceGroupName $Name `
    -Location $Location `
    -AddressPrefix 10.0.0.0/16 `
    -Subnet $Subnet

# Create two virtual machines
New-AzVM `
    -ResourceGroupName $Name `
    -Name "myVm001" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "default" `
    -Image "Win2016Datacenter" `
    -Size "Standard_DS2_v2"

# get the public IP address
Get-AzPublicIpAddress -Name "myVm001"

# Create the second VM named
New-AzVM `
    -ResourceGroupName $Name `
    -Name "myVm002" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "default" `
    -Image "Win2016Datacenter" `
    -Size "Standard_DS2_v2"

# Disassociate the public IP address that was created by default for the VM.
$nic = Get-AzNetworkInterface -Name myVm002 -ResourceGroupName $Name 
$nic.IpConfigurations.publicipaddress.id = $null
Set-AzNetworkInterface -NetworkInterface $nic
```