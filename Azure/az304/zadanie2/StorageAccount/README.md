## Zad 2 Utwórz konto składowania danych. 
> Upewnij się, że ruch do konta składowania danych odbywa się tylko ze wskazanej sieci i wykorzystuje prywatny adres IP. 
Pokaż, że faktycznie tak się dzieje.

### 2.1 REsource Group
```bash
# Zmienne
export myResourceGroup=rg-zjazd-drugi
export location=westeurope

#Resource group
az group create \
--name $myResourceGroup \
--location $location

```
### 1.2 Vnet + bastion + drugi subnet

> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/VNET_BAS/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/VNET_BAS/parameters.json)


```bash
az deployment group create \
--resource-group $myResourceGroup \
--template-file ~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/VNET_BAS/template.json \
--parameters ~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/VNET_BAS/parameters.json


```

### 1.3 WIN 10 w default subnet

> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/WIN10/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/WIN10/parameters.json)

```bash

# Potrzebuję vnet id do zmiany w template win 10
az network vnet show -g $myResourceGroup -n vnet-zjazd-drugi --query "id"

    "/subscriptions/4c18ac9c-3885-4370-baf7-bf15e9c3f783/resourceGroups/rg-zjazd-drugi/providers/Microsoft.Network/virtualNetworks/vnet-zjazd-drugi"

# Wynik
az vm list-ip-addresses -n win10-vm01 -o table

    VirtualMachine    PrivateIPAddresses
    ----------------  --------------------
    win10-vm01        10.1.0.4

```

### 1.4 Storage account
> [template-file](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/SA/template.json)

> [parameters](~/local_repo/Szkola_Chmury/Azure/az304/zadanie2/StorageAccount/SA/parameters.json)

### Testy

> Połączyłem się przez bastion z VM. 
   
    PS C:\Users\krolik> nslookup sazjazddrugi.blob.core.windows.net
    Server:  UnKnown
    Address:  168.63.129.16

    Non-authoritative answer:
    Name:    sazjazddrugi.privatelink.blob.core.windows.net
    Address:  10.1.0.5
    Aliases:  sazjazddrugi.blob.core.windows.net
