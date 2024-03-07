// Parameters

@description('Name of the WebApp Frontend')
param name_frontend string

@description('Name of the WebApp Backend')
param name_backend string

@description('Location of the WebApp')
param location string

@description('Subnet of the WebApp for vnet integration')
param subnet_id string

@description('Name of the registry in which the container image resides')
param registry_name string

@description('Name of the container image that is going to be deployed through the Webapp Backend')
param image_name_backend string

@description('Name of the container image that is going to be deployed through the Webapp Fronmtend')
param image_name_frontend string

@description('App Service Plan ID of the WebApp')
param app_service_plan_id string

@description('Instrumentation key for the Application Insights to be linked to')
param app_insights_key string

@description('Specifies whether always on is enabled')
param always_on bool

@description('PropelAuth API Key')
param propelauth_api_key string

// Resources

resource webapp_backend 'Microsoft.Web/sites@2022-03-01' = {
  name: name_backend
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    virtualNetworkSubnetId: subnet_id
    vnetRouteAllEnabled: true
    vnetImagePullEnabled: true
    vnetContentShareEnabled: true

    siteConfig: {
      acrUseManagedIdentityCreds: true
      alwaysOn: always_on
      appSettings: [ {
          name: 'WEBSITE_PULL_IMAGE_OVER_VNET'
          value: 'true' }
        { name: 'PROPELAUTH_AUTH_URL'
          value: 'https://0191962.propelauthtest.com'
        }
        { name: 'WEBSITE_VNET_ROUTE_ALL'
          value: 'true' }
        {
          name: 'PROPELAUTH_API_KEY'
          value: propelauth_api_key

        }
        {
          name: 'WEBSITES_PORT'
          value: '80' }
        {
          name: 'PORT'
          value: '3001'
        } ]
      linuxFxVersion: 'DOCKER|${registry_name}.azurecr.io/${image_name_backend}:latest'
    }

    serverFarmId: app_service_plan_id
  }
}

resource webapp_frontend 'Microsoft.Web/sites@2022-03-01' = {
  name: name_frontend
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    virtualNetworkSubnetId: subnet_id
    vnetRouteAllEnabled: true
    vnetImagePullEnabled: true
    vnetContentShareEnabled: true

    siteConfig: {
      acrUseManagedIdentityCreds: true
      alwaysOn: always_on
      appSettings: [
        {
          name: 'WEBSITE_PULL_IMAGE_OVER_VNET'
          value: 'true'
        }
        { name: 'WEBSITE_VNET_ROUTE_ALL'
          value: 'true' }
        {
          name: 'WEBSITES_PORT'
          value: '80' }
        {
          name: 'PORT'
          value: '3000'
        } ]
      linuxFxVersion: 'DOCKER|${registry_name}.azurecr.io/${image_name_frontend}:latest'
    }

    serverFarmId: app_service_plan_id
  }
}

// Outputs

output webapp_backend_id string = webapp_backend.id
output webapp_backend_name string = webapp_backend.name
output webapp_backend_url string = webapp_backend.properties.hostNames[0]
output webapp_backend_identity_principal_id string = webapp_backend.identity.principalId

output webapp_frontend_id string = webapp_frontend.id
output webapp_frontend_name string = webapp_frontend.name
output webapp_frontend_url string = webapp_frontend.properties.hostNames[0]
output webapp_frontend_identity_principal_id string = webapp_frontend.identity.principalId
