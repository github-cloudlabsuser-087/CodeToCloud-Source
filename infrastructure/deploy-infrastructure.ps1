<<<<<<< HEAD
$studentsuffix = "410092"
$resourcegroupName = "fabmedical-rg-" + $studentsuffix
$cosmosDBName = "fabmedical-cdb-" + $studentsuffix
$webappName = "fabmedical-web-" + $studentsuffix
$appInsights = "fabmedicalai-" + $studentsuffix
$planName = "fabmedical-plan-" + $studentsuffix
$location1 = "westeurope"
$location2 = "northeurope"
=======
param
(
    [string] $studentprefix = "tst"
)

$resourcegroupName = "fabmedical-rg-" + $studentprefix
$cosmosDBName = "fabmedical-cdb-" + $studentprefix
$webappName = "fabmedical-web-" + $studentprefix
$planName = "fabmedical-plan-" + $studentprefix
$location1 = "westeurope"
$location2 = "northeurope"
$appInsights = "fabmedicalai-" + $studentsuffix

#First create a group
$rg = az group create --name $resourcegroupName --location $location1 | ConvertFrom-Json 
>>>>>>> 48845cd681a88ec5cb8ec15121d58fceff0fcad8

#Then create a CosmosDB
az cosmosdb create --name $cosmosDBName `
--resource-group $resourcegroupName `
--locations regionName=$location1 failoverPriority=0 isZoneRedundant=False `
--locations regionName=$location2 failoverPriority=1 isZoneRedundant=True `
--enable-multiple-write-locations `
<<<<<<< HEAD
--kind MongoDB 
=======
--kind MongoDB
>>>>>>> 48845cd681a88ec5cb8ec15121d58fceff0fcad8

#Create a Azure App Service Plan
az appservice plan create --name $planName --resource-group $resourcegroupName --sku S1 --is-linux

<<<<<<< HEAD
#Create a Azure Web App with NGINX container
az webapp create --resource-group $resourcegroupName --plan $planName --name $webappName -i nginx

#Create the Applications Insights service
az extension add --name application-insights
$ai = az monitor app-insights component create --app $appInsights --location $location1 --kind web -g $resourcegroupName --application-type web --retention-time 120 | ConvertFrom-Json

Write-Host "AI Instrumentation Key=$($ai.instrumentationKey)"
=======
az webapp config appsettings set --settings DOCKER_REGISTRY_SERVER_URL="https://ghcr.io" --name $($webappName) --resource-group $($resourcegroupName) 
az webapp config appsettings set --settings DOCKER_REGISTRY_SERVER_USERNAME="notapplicable" --name $($webappName) --resource-group $($resourcegroupName) 
az webapp config appsettings set --settings DOCKER_REGISTRY_SERVER_PASSWORD="$($env:CR_PAT)" --name $($webappName) --resource-group $($resourcegroupName) 


#Create a Azure Web App with NGINX container
az webapp create `
--multicontainer-config-file docker-compose.yml `
--multicontainer-config-type COMPOSE `
--name $($webappName) `
--resource-group $($resourcegroupName) `
--plan $($planName)

az webapp config container set `
--docker-registry-server-password $($env:CR_PAT) `
--docker-registry-server-url https://ghcr.io `
--docker-registry-server-user notapplicable `
--multicontainer-config-file docker-compose.yml `
--multicontainer-config-type COMPOSE `
--name $($webappName) `
--resource-group $resourcegroupName 

az extension add --name application-insights
az monitor app-insights component create --app $appInsights --location $location1 --kind web -g $resourcegroupName --application-type web --retention-time 120

>>>>>>> 48845cd681a88ec5cb8ec15121d58fceff0fcad8
