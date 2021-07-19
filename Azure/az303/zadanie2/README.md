# [Zadanie domowe - Tydzień 2](https://portal.szkolachmury.pl/products/az-303-microsoft-azure-architect-technologies/categories/2147540285/posts/2147680370)

### TYDZIEN 2.1</b> 
* Zbuduj prostą konwencję nazewniczą dla min. takich zasobów jak:
    * Grupa Zasobów
    * VNET    
    * Maszyn Wirtualna
    * Dysk
    * Konta składowania danych. 

    Pamiętaj o ograniczeniach w nazywaniu zasobów, które występują w Azure</br></br>
---
| zasób                     | Schemat nazwy                                             | przykład                      |
|---------------------------|-----------------------------------------------------------|-------------------------------|
| Grupa Zasobów             | \<project/app\>-\<env\>-rg                                | superproj-test-rg             |
| VNET                      | \<env\>-\<region\>-\<###\>-vnet                           | test-westus-001-vnet          |
| Maszyna Wirtualna         | \<policy name or app name\>\<###\>-\<OS\>Vm               | AppName001UbuntuVm            |
| Dysk                      | \<purpose\>\<###\>Disk                                    | logs001Disk                   |
| Konta składowania danych  | \<project/app\>\<###\>Stor                                | superapp001Stor       |

---
###<b>TYDZIEN 2.2</b> 
* Zbuduj prosty ARM Template (możesz wykorzystać już gotowe wzorce z GitHub), który wykorzystuje koncepcję Linked Templates. Template powinien zbudować środowisko złożone z jednej sieci VNET, podzielonej na dwa subnety. W każdy subnecie powinna powstać najprostsza maszyna wirtualna z systemem Ubuntu 18.04 a na każdym subnecie powinny zostać skonfigurowane NSG.</br></br>





---
* <b>TYDZIEN 2.3</b> Zbuduj najprostrzą właśną rolę RBAC, która pozwala użytkownikowi uruchomić maszynę, zatrzymać ją i zgłosić zgłoszenie do supportu przez Portal Azure
---
* <b>TYDZIEN 2.4</b> Spróbuj na koniec zmodyfikować template tak, by nazwa użytkownika i hasło do każdej maszyny z pkt. 2 było pobierane z KeyVault.
