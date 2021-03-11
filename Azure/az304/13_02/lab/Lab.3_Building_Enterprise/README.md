# AZ-304 T3-Lab.3 Building Enterprise

### 1. Create an Event Hub namespace

```bash
# Zmienne
export myResourceGroup=lab3-zjazd3-rg
export location=westeurope

# Respurce group
az group create \
-n $myResourceGroup \
-l $location
```

<details>
  <summary><b><i>Deployment json dla EventHUB z consumergroup</i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {
        "eventHubNamespaceName": "lab3-zjazd3-eh-nmspc",
        "eventHubName": "dataBroker",
        "skuName": "Standard",
        "skuTier": "Standard",
        "skuCapacity": 1,
        "consumerGroupName": "eventhub",
        "location": "[resourceGroup().location]"
    },
    "resources": [
        {
            "type": "Microsoft.EventHub/namespaces",
            "apiVersion": "2018-01-01-preview",
            "name": "[variables('eventHubNamespaceName')]",
            "location": "[variables('location')]",
            "sku": {
                "name": "[variables('skuName')]",
                "tier": "[variables('skuTier')]",
                "capacity": "[variables('skuCapacity')]"
            },
            "properties": {
                "isAutoInflateEnabled": false,
                "zoneRedundant": false,
                "kafkaEnabled": false

            },
            "resources": [
                {
                    "type": "eventhubs",
                    "apiVersion": "2017-04-01",
                    "name": "[variables('eventHubName')]",
                    "location": "[variables('location')]",
                    "dependsOn": [
                        "[resourceId('Microsoft.EventHub/namespaces', variables('eventHubNamespaceName'))]"
                    ],
                    "properties": {
                        "partitionCount": 2,
                        "messageRetentionInDays": 1

                    },
                    "resources": [
                        {
                            "type": "consumergroups",
                            "apiVersion": "2017-04-01",
                            "name": "[variables('consumerGroupName')]",
                            "dependsOn": [ "[resourceId('Microsoft.EventHub/namespaces/eventhubs', variables('eventHubNamespaceName'), variables('eventHubName'))]" ],
                            "properties": {}
                        }
                    ]
                }
            ]

        }
    ]
}
```
</details>

```bash
# Deployment ARM NameSpape i EventHUB
az deployment group create \
-n EventHubv1
--resource-group $myResourceGroup \
--template-file azuredeploy.json

# Dlaczego wynikiem jet KAFKA SURFACE ENABLED ?
```
> SAS Zrobiony w portalu. Na chwilę obecną nie umiem go zrobić po hakersku.

### 2 Create Docker Image
```bash
# Zmienne
export containerRegistryName=lab3zjazd3acr

# Pobieram pliki
wget https://github.com/cloudstateu/AZ304/raw/main/Lab3/ContainerApp.zip \
&& unzip ContainerApp.zip \
&& cd ContainerApp \
&& code .

# Create ACR - tak mi jakoś było szybciej
az acr create --resource-group $myResourceGroup \
--name $containerRegistryName \
--sku Basic \
--admin-enabled true

# Kompilowanie i wypychanie obrazu z pliku dockerfile (w Azure CloudShell - bo po co to ciągnąć na lokalną maszynę a potem wypu=ychać na Azure, jak można to zrobić odrazu tam)
az acr build --image containerapp \
  --registry lab3zjazd3acr \
  --file Dockerfile .

```

### 3 Create ACI

<details>
  <summary><b><i>Deployment json dla ACI </i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "ports": {
            "type": "array"
        }
    },
    "variables": {
        "location": "[resourceGroup().location]",
        "name": "zad3-zjazd3-aci",
        "imageName": "lab3zjazd3acr.azurecr.io/containerapp:latest",
        "cpuCores": "1",
        "memoryInGB": "1.5",
        "restartPolicy": "OnFailure",
        "osType": "Linux",
        "username": "lab3zjazd3acr",
        "imageRegistryLoginServer": "lab3zjazd3acr.azurecr.io",
        "dnsNameLabel": "dnsname-lab3-container",
        "password": "e77zhCnxkXTDCVtMlIBwaQcTfccy//zj"

    },
    "resources": [
        {
            "type": "Microsoft.ContainerInstance/containerGroups",
            "apiVersion": "2019-12-01",
            "name": "[variables('name')]",
            "location": "[variables('location')]",
            "properties": {
                "containers": [
                    {
                        "name": "[variables('name')]",
                        "properties": {
                            "image": "[variables('imageName')]",
                            "ports": "[parameters('ports')]",
                            "resources": {
                                "requests": {
                                    "cpu": "[variables('cpuCores')]",
                                    "memoryInGB": "[variables('memoryInGB')]"
                                }
                            }

                        }
                    }
                ],
                "restartPolicy": "[variables('restartPolicy')]",
                "osType": "[variables('osType')]",
                "imageRegistryCredentials": [
                    {
                        "username": "[variables('username')]",
                        "server": "[variables('imageRegistryLoginServer')]",
                        "password": "[variables('password')]"
                    }
                ],
                "ipAddress": {
                    "type": "Public",
                    "ports": "[parameters('ports')]",
                    "dnsNameLabel": "[variables('dnsNameLabel')]"
                }

            }
        }
    ]
}
```

</details>

<br>

<details>
  <summary><b><i>Oraz paramsy dla ACI </i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "ports": {
            "value": [
                {
                    "port": "80",
                    "protocol": "TCP"
                }
            ]
        }
    }
}

```
</details>

<br>

```bash
# Deployment 
az deployment group create \
-n ACIv1 \
--resource-group $myResourceGroup \
--template-file azuredeploy.json \
--parameters azuredeploy.parameters.json

```

### 4 Create Service Bus with 3 topics

<details>
  <summary><b><i>Deployment json dla ServiceBus Namespace </i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "functions": [],
    "variables": {
        "serviceBusNamespaceName": "lab3-zjazd3-sb-nmsc"
    },
    "resources": [
        {
            "type": "Microsoft.ServiceBus/namespaces",
            "apiVersion": "2018-01-01-preview",
            "name": "[variables('serviceBusNamespaceName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "tier": "Standard",
                "name": "Standard"
            },
            "properties": {}
        }
    ]
}
```
</details>

```bash
#Pierwsze wdrożenie samego NameSpace
az deployment group create \
-n "ServiceBus" \
-g $myResourceGroup \
--template-file = azuredeploy.json \
--parameters = @azuredeploy.parameters.json 
```

<details>
  <summary><b><i>Deployment json dla ServiceBus Topics </i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "maxTopicSize": {
            "type": "int"
        },
        "MessageTimeToLive": {
            "type": "string"

        }
    },
    "variables": {
        "serviceBusNamespaceName": "lab3-zjazd3-sb-nmsc",
        "topicName1": "topic-krolik-1",
        "skuTier": "Standard",
        "skuName": "Standard",
        "subName1": "s1-krolik-sb"
    },
    "resources": [
        {
            "type": "Microsoft.ServiceBus/namespaces",
            "apiVersion": "2017-04-01",
            "name": "[variables('serviceBusNamespaceName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "tier": "[variables('skuTier')]",
                "name": "[variables('skuName')]"
            },
            "properties": {},
            "resources": [
                {
                    "type": "topics",
                    "apiVersion": "2017-04-01",
                    "name": "[variables('topicName1')]",
                    "dependsOn": [ "[resourceId('Microsoft.ServiceBus/namespaces', variables('serviceBusNamespaceName'))]" ],
                    "properties": {
                        "maxSizeInMegabytes": "[parameters('maxTopicSize')]",
                        "defaultMessageTimeToLive": "[parameters('MessageTimeToLive')]",
                        "requiresDuplicateDetection": false,
                        "enablePartitioning": true
                    },
                    "resources": [
                        {
                            "type": "subscriptions",
                            "apiVersion": "2017-04-01",
                            "name": "[variables('subName1')]",
                            "dependsOn": [ "[resourceId('Microsoft.ServiceBus/namespaces/topics', variables('serviceBusNamespaceName'), variables('topicName1'))]" ],
                            "properties": {}

                        }

                    ]
                }
            ]
        }
    ]

}
```
</details>

<details>
  <summary><b><i>Parametry json dla ServiceBus Topics </i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "maxTopicSize": {
            "value": 1024
        },
        "MessageTimeToLive": {
            "value": "7"
        }
    }
}
```
</details>

```bash
# Walidacja z jednym topickiem i jedna sybskrybcją
az deployment group validate \
-g $myResourceGroup \
--template-file azuredeploy.json \
--parameters=@azuredeploy.parameters.json

#Przeszła OK Dodaję 2 kolejne topicki
```
<details>
  <summary><b><i>Deployment json dla ServiceBus i 3 Topics z subskrybcjami</i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "maxTopicSize": {
            "type": "int"
        },
        "MessageTimeToLive": {
            "type": "string"
        },
        "TopicCount": {
            "type": "int"
        },
        "deliverCount": {
            "type": "int"
        }
    },
    "variables": {
        "serviceBusNamespaceName": "lab3-zjazd3-sb-nmsc",
        "skuTier": "Standard",
        "skuName": "Standard",
        "copy": [
            {
                "name": "subName",
                "count": "[parameters('TopicCount')]",
                "input": "[concat('sub-', copyIndex('subName', 1))]"
            }
        ]

    },
    "resources": [
        {
            "type": "Microsoft.ServiceBus/namespaces",
            "apiVersion": "2017-04-01",
            "name": "[variables('serviceBusNamespaceName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "tier": "[variables('skuTier')]",
                "name": "[variables('skuName')]"
            },
            "properties": {}
        },
        {
            "type": "Microsoft.ServiceBus/namespaces/topics",
            "apiVersion": "2017-04-01",
            "dependsOn": [ "[resourceId('Microsoft.ServiceBus/namespaces', variables('serviceBusNamespaceName'))]" ],
            "name": "[concat(variables('serviceBusNamespaceName'),'/','krolik-topic-',copyIndex('TopicCopy',1))]",
            "properties": {
                "maxSizeInMegabytes": "[parameters('maxTopicSize')]",
                "defaultMessageTimeToLive": "[parameters('MessageTimeToLive')]",
                "requiresDuplicateDetection": false,
                "enablePartitioning": true
            },
            "copy": {
                "count": "[parameters('TopicCount')]",
                "name": "TopicCopy"
            },
            "resources": [
                {
                    "type": "subscriptions",
                    "apiVersion": "2017-04-01",
                    "name": "[variables('subName')[copyIndex()]]",
                    "dependsOn": [ "[resourceId('Microsoft.ServiceBus/namespaces/topics', variables('serviceBusNamespaceName'), concat('krolik-topic-', copyIndex('TopicCopy',1)))]" ],
                    "properties": {
                        "maxDeliveryCount": "[parameters('deliverCount')]"
                    }
                }
            ]
        }
    ]
}
```
</details>

<details>
  <summary><b><i>Parametry json dla ServiceBus i 3 Topics z subskrybcjami</i></b></summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "MessageTimeToLive": {
            "value": "P7D"
        },
        "TopicCount": {
            "value": 3
        },
        "maxTopicSize": {
            "value": 1024
        },
        "deliverCount": {
            "value": 10
        }
    }
}
```
</details>

```bash
# Deployb ServiceBus i 3 Topicki
az deployment group create \
-n "ServiceBusAnd3Topic" \
-g $myResourceGroup \
--template-file  azuredeploy.json \
--parameters  @azuredeploy.parameters.json
```


### 5 Create AF between Event Hub and Service Bus
> Tą część wyklikałem w portalu. Obecny stan wiedzy każe ćwiczyć ;> <br> ARM template poniżej został wygenerpwany z gotowego środowiska.
