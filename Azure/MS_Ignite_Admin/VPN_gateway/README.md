# [Create an Azure VPN gateway](https://docs.microsoft.com/en-us/learn/modules/configure-network-for-azure-virtual-machines/5-exercise-create-azure-vpn-gateway)

## You will carry out the following process:

    * Create a RouteBased VPN gateway.

    * Upload the public key for a root certificate for authentication purposes.

    * Generate a client certificate from the root certificate, and then install the client certificate on each client computer that will connect to the virtual network for authentication purposes.

    * Creae VPN client configuration files, which contain the necessary information for the client to connect to the virtual network.

### Setup
```powershell
# variables
$VNetName  = "VNetData"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"
$VNetPrefix1 = "192.168.0.0/16"
$VNetPrefix2 = "10.254.0.0/16"
$FESubPrefix = "192.168.1.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$ResourceGroup = "VpnGatewayDemo"
$Location = "East US"
$GWName = "VNetDataGW"
$GWIPName = "VNetDataGWPIP"
$GWIPconfName = "gwipconf"
```
### Configure a virtual network
```powershell
# create a resource group
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# subnet configurations for the virtual network

$fesub = New-AzVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$besub = New-AzVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $BESubPrefix
$gwsub = New-AzVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix

# create the virtual network using the subnet values and a static DNS server
New-AzVirtualNetwork `
    -Name $VNetName `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -AddressPrefix $VNetPrefix1, $VNetPrefix2 `
    -Subnet $fesub, $besub, $gwsub `
    -DnsServer 10.2.1.3

# variables for this network
$vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroup
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $GWSubName -VirtualNetwork $vnet

# request a dynamically assigned public IP address.
$pip = New-AzPublicIpAddress `
    -Name $GWIPName `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -AllocationMethod Dynamic

$ipconf = New-AzVirtualNetworkGatewayIpConfig `
    -Name $GWIPName `
    -Subnet $subnet `
    -PublicIpAddress $pip
```

### Create the VPN gateway

```powershell
# create the VPN gateway

```