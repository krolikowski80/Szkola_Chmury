# [Zadanie domowe - Tydzień 2](https://szkolachmury.pl/az-303-microsoft-azure-architect-technologies/tydzien-2-application-architecture-patterns-in-azure/praca-domowa/)

### TYDZIEN 2.1</b> 
* Zbuduj prostą konwencję nazewniczą dla min. takich zasobów jak:
    * Grupa Zasobów
    * VNET    
    * Maszyn Wirtualna
    * Dysk
    * Konta składowania danych. 

    Pamiętaj o ograniczeniach w nazywaniu zasobów, które występują w Azure</br></br>

* Grupa Zasobów -                           \<project/app\>-\<env\>-rg ,                    np: superapp-test-rg
* VNET -                                    \<project/app\>-\<env\>-\<region\>-vnet ,       np: superapp-test-ne-vnet
* Maszyn Wirtualna                          \<project/app\>-\<env\>-\<instance>\<OS\>-vm ,  np: superapp-test-01-ubuntu20-vm
* Dysk                                      \<project/app\>-\<env\>-\<instance>-disk ,      np: superapp-test-01-vm
* Konta składowania danych.                 \<project/app\>\<env\>\<purpose\>stor ,         np: superapptestlogsstor

---
###<b>TYDZIEN 2.2</b> 
* Zbuduj prosty ARM Template (możesz wykorzystać już gotowe wzorce z GitHub), który wykorzystuje koncepcję Linked Templates. Template powinien zbudować środowisko złożone z jednej sieci VNET, podzielonej na dwa subnety. W każdy subnecie powinna powstać najprostsza maszyna wirtualna z systemem Ubuntu 18.04 a na każdym subnecie powinny zostać skonfigurowane NSG.</br></br>


#### Resource group
```bash
# Zmienne
export myResourceGroup=zadanie2-szkchm-rg
export location=westeurope

#Resource group
az group create \
-n $myResourceGroup \
-l $location



```

---
* <b>TYDZIEN 2.3</b> Zbuduj najprostrzą właśną rolę RBAC, która pozwala użytkownikowi uruchomić maszynę, zatrzymać ją i zgłosić zgłoszenie do supportu przez Portal Azure
---
* <b>TYDZIEN 2.4</b> Spróbuj na koniec zmodyfikować template tak, by nazwa użytkownika i hasło do każdej maszyny z pkt. 2 było pobierane z KeyVault.