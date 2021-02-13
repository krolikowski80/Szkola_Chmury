# AZ-304 Azure DevOps Lab

> In this lab you will learn how to manage builds and deployments with Azure DevOps. You
will create an organization with a repository hosting your application code. Next you will
create a Build Pipeline which will run every time code is pushed to master branch. Also the
deployment will be handled by DevOps service – app will be published to Azure App Service
every time build succeeded.

```bash
# zmienne
export myResourceGroup=zjzd3-lab2-rg
export location=westeurope

# resource group
az group create \
-n $myResourceGroup \
-l $location

# deploy web app
az deployment group create \
--resource-group $myResourceGroup \
--template-file template.json \
--parameters parameters.json