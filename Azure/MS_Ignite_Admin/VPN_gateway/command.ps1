$VNetName = "VNetData"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"
$VNetPrefix1 = "192.168.0.0/16"
$VNetPrefix2 = "10.254.0.0/16" 
$FESubPrefix = "192.168.11.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$ResourceGroup = "VpnGatewayDemo"
$Location = "westeurope"
$GWName = "VNetDataGW"
$GWIPName = "VNetDataGWPIP"
$GWIPconfName = "gwipconf"

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

# create the VPN gateway
New-AzVirtualNetworkGateway `
    -Name $GWName `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -IpConfigurations $ipconf `
    -GatewayType Vpn `
    -VpnType RouteBased `
    -EnableBgp $false `
    -GatewaySku VpnGw1 `
    -VpnClientProtocol "IKEv2"

# Add the VPN client address pool
$Gateway = Get-AzVirtualNetworkGateway -ResourceGroupName $ResourceGroup -Name $GWName
Set-AzVirtualNetworkGateway `
    -VirtualNetworkGateway $Gateway `
    -VpnClientAddressPool $VPNClientAddressPool

# Generate a client certificate
