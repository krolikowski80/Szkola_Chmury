## zad 1 Wykorzystaj Azure Firewall do ustawienia połączeń RDP z Internetu do maszyny po prywatnej adresacji
### 1.1 REsource Group
```bash
# Zmienne
export myResourceGroup=rg-zjazd-drugi
export location=westeurope

#Resource group
az group create \
--name $myResourceGroup \
--location $location

```
### 1.2 Vnet i subnety 
> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/VNET/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/VNET/parameters.json)

```bash
# FF-VNET
az deployment group create \
--resource-group $myResourceGroup \
--template-file ~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/VNET/template.json \
--parameters ~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/VNET/parameters.json

```

### 1.3 Windows 10 bez public IP w subnecie BackEndPool 
> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/WIN10/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/WIN10/parameters.json)

# Po minutach kilku, mym oczom ukazała się VM - tylko z lokalnym IP = 10.1.0.4
az vm list-ip-addresses -n win10-vm01 -o table

    VirtualMachine    PrivateIPAddresses
    ----------------  --------------------
    win10-vm01        10.0.2.4
```

### 1.4 Firewall
> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/FF/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/FF/parameters.json)


### 1.5 Routing
> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/ROUTE/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/firewall_VM_no_PIP/ROUTE/parameters.json)

### Wynik
> Działa ;>