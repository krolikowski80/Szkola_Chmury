## 1. Spróbuj utworzyć zestaw polityk, które spełniają następująceoczekiwania i zapisz swoje wymiki prac:

### [First aid](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure?fbclid=IwAR3ZVvyDNXJcyD1NmHHpQZRjQ1rh5KqczKiwTOZe0JdJNuaMkJKWPS2DeK4#conditions)

### [Emergency assistance](https://docs.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies)



<details>
  <summary><b><i> - 1.1 polityka zabrania stworznia konta typu Azure Storage, które umożliwia dostępu z tzw. Public Endpoints</i></b></summary>

```json
{
    "mode": "Indexed",
    "policyRule": {
        "if": {
            "allOf": [
                {
                    "field": "type",
                    "equals": "Microsoft.Storage/storageAccounts"
                },
                {
                    "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
                    "equals": "false"
                }
            ]
        },
        "then": {
            "effect": "deny"
        }
    }
}

```
</details>

---


<details>
  <summary><b><i> - 1.2 polityka zabrania tworzenia serwerów Azure SQL, dostępnych publicznie</b></i></summary>

  ```json
{
    "mode": "Indexed",
    "parameters": {
        "effect": {
            "type": "String",
            "metadata": {
                "displayName": "Effect",
                "description": "Enable or disable the execution of the policy"
            },
            "allowedValues": [
                "Audit",
                "Deny",
                "Disabled"
            ],
            "defaultValue": "Audit"
        }
    },
    "policyRule": {
        "if": {
            "allOf": [
                {
                    "field": "type",
                    "equals": "Microsoft.Sql/servers"
                },
                {
                    "field": "Microsoft.Sql/servers/publicNetworkAccess",
                    "notEquals": "Disabled"
                }
            ]
        },
        "then": {
            "effect": "[parameters('effect')]"
        }
    }
}

```
```bash
az sql server create \
-l northeurope \
-g zad1_az304 \
-n myserver \
-u myadminuser \
-p myadminpassword \
-e

# --enable-public-network -e
#Set whether public network access to server is allowed or not. When false,only connections made through Private Links can reach this server.

# Wynik
    ForbiddenError: Resource 'myserver' was disallowed by policy. Policy identifiers: '[{"policyAssignment":{"name":"NoPubicSqlServer","id":"/subscriptions/4c18ac9c-3885-4370-baf7-bf15e9c3f783/resourceGroups/zad1_az304/providers/Microsoft.Authorization/policyAssignments/6d12e6a38d45471eb716a623"},"policyDefinition":{"name":"NoPubicSqlServer","id":"/subscriptions/4c18ac9c-3885-4370-baf7-bf15e9c3f783/providers/Microsoft.Authorization/policyDefinitions/2c844f43-6864-42be-ad04-57effeb92616"}}]'.
```

</details>

---



<details>
  <summary><b><i> - 1.3 polityka zabrania tworzenia zasobów, które nie mają Tag'u o nazwie Project</b></i></summary>

  ```json
{
    "mode": "Indexed",
    "parameters": {
        "tagName": {
            "type": "String",
            "metadata": {
                "displayName": "Tag Name",
                "description": "Name of the tag, such as 'environment'"
            }
        }
    },
    "policyRule": {
        "if": {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": "false"
        },
        "then": {
            "effect": "deny"
        }
    }
}

  ```
</details>

---


<details>
  <summary><b><i> - 1.4 polityka zabrania tworzenia zasobów, które nie mają Tag'u o nazwie Owner i którego zawartość nie zawiera maila np. w domenie chmurowisko.pl. Czyli tag Owner o wartości michal@chmurowisko.pl jest OK. ale tag o wartości michal@chmurowiskolab.com już nie</b></i></summary>

```json
{
    "mode": "Indexed",
    "parameters": {
        "tagName": {
            "type": "String",
            "metadata": {
                "displayName": "User role",
                "description": "Name of the tag, such as 'Owner, tester, developer'"
            }
        },
        "tagValue": {
            "type": "String",
            "metadata": {
                "displayName": "valid email address",
                "description": "Value of the tag, such as 'valid email address'"
            }
        }
    },
    "policyRule": {
        "if": {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "notLike": "[concat('*@', parameters('tagValue'))]"
        },
        "then": {
            "effect": "deny"
        }
    }
}
```
</details>

---

<details>
  <summary><b><i> - 1.5 polityka wymusza by każda stworzona maszyna była od razu podłączona do usługiAzure Log Analytics, które będzie parameterem polityki</b></i></summary>

```bash

 ¯\_(ツ)_/¯ 

```

[Linux VM](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Monitoring/LogAnalyticsExtension_Linux_VM_Deploy.json) oraz [Windows VM](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Monitoring/LogAnalyticsExtension_Windows_VM_Deploy.json)


</details>

## 2 Spróbuj stworzyć 3 nowe role i sprawdź ich działanie tworząc 3 urzytkowników dla potrzeb testów:
> Uwaga: rola domyślnie nie może nic ponad to, co opisano niżej. A więc rola SecurityEng może tylko tworzyć zapytania i nic ponad to.

* **Rola: ProjectOwner**
    * może zarządzać usługami Virtual Machines, Azure Kubernetes Services, Storage Account
    * nie może modfikować usług sieciowych (Microsoft.Network)
    * nie może modyfikować usługi Azure Log Analytics
---
* **Rola: SecurityManager:**
    * może modyfikować: Azure Security Center, Azure Log Analytics
    * nie może tworzyć: Azure Security Center, Azure Log Analytics
    * może tworzyć alerty
    ---
* **Rola: SecurityEng**
    * może: tworzyć zapytania w ramach Azure Log Analytics