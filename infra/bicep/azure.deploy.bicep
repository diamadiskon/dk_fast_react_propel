targetScope = 'subscription'

/// Parameters ///

@description('Azure region used for the deployment of all resources')
param location string

@description('Abbreviation fo the location')
param location_abbreviation string

@description('Name of the workload that will be deployed')
param workload string

@description('Name of the workloads environment')
param environment string

@description('Tags to be applied on the resource group')
param rg_tags object = {}

@description('Username of the jumpbox admin')
param jumpbox_admin_username string

@description('Password of the jumpbox admin')
@secure()
param jumpbox_admin_password string

@description('Username of the mysql admin')
param cosmosdb_admin_username string

@description('Password of the cosmosdb admin')
@secure()
param cosmosdb_admin_password string

@secure()
@description('PAT azure devops')
param azurePAT string

@description('Azure DevOps Organization URL')
param AzureDevOpsURL string

@description('Self hosted pool name')
param AgentPoolName string

// @secure()
// @description('Base64 server certificate data for the AG')
// param serverCertificateData string

// @secure()
// @description('Password for the certificate')
// param serverCertificatePassword string

// @description('FQDN for SummerProject')
// param fqdn string

@description('Name of the secret that will store the mysql admin password')
#disable-next-line secure-secrets-in-params
param cosmosdb_admin_password_secret_name string

@description('Name of the secret that will store the jumpbox admin password')
#disable-next-line secure-secrets-in-params
param jumpbox_admin_password_secret_name string

@description('Address Space for Virtual Network')
param vnet_address_space array

@description('Address Prefix for Application Gateway Subnet')
param snet_agw_address_prefix string

@description('Address Prefix for Azure Kubernetes Service Subnet')
param snet_aks_address_prefix string

@description('Address Prefix for cosmosdb Server Subnet')
param snet_cosmosdb_address_prefix string

@description('Address Prefix for Shared Resources Subnet')
param snet_shared_address_prefix string

@description('Address Prefix for Bastion Subnet')
param snet_bastion_address_prefix string

/// Variables ///

var tags = union(
  {
    workload: workload
    environment: environment
  },
  rg_tags
)

@description('Availability zone numbers e.g. 1,2,3.')
param availability_zones array = [
  '1'
  '2'
  '3'
]

/// Variables ///

var suffix = '${workload}-${environment}-${location_abbreviation}'

var rg_name = 'rg-${suffix}'

var rg_tags_final = union(
  {
    workload: workload
    environment: environment
  },
  tags
)

/// Modules & Resources ///

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
  tags: rg_tags_final
}

// Azure Naming module deployment - this will generate all the names of the resources at deployment time.
module naming 'modules/naming.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'azure-naming-deployment'
  params: {
    location: location
    suffix: [
      workload
      environment
      '**location**' // azure-naming location/region placeholder, it will be replaced with its abbreviation
    ]
    uniqueLength: 5
    uniqueSeed: resourceGroup.id
    useDashes: true
    useLowerCase: true
  }
}

module main 'main.bicep' = {
  name: 'deployment-${suffix}'
  scope: az.resourceGroup(resourceGroup.name)

  params: {
    rg_name: resourceGroup.name
    environment: environment
    workload: workload
    location: location
    location_abbreviation: location_abbreviation
    naming: naming.outputs.names
    jumpbox_admin_username: jumpbox_admin_username
    jumpbox_admin_password: jumpbox_admin_password
    jumpbox_admin_password_secret_name: jumpbox_admin_password_secret_name
    cosmosdb_admin_password: cosmosdb_admin_password
    cosmosdb_admin_password_secret_name: cosmosdb_admin_password_secret_name
    vnet_address_space: vnet_address_space
    snet_agw_address_prefix: snet_agw_address_prefix
    snet_aks_address_prefix: snet_aks_address_prefix
    snet_bastion_address_prefix: snet_bastion_address_prefix
    snet_cosmosdb_address_prefix: snet_cosmosdb_address_prefix
    snet_shared_address_prefix: snet_shared_address_prefix
    availability_zones: availability_zones
    azurePAT: azurePAT
    AzureDevOpsURL: AzureDevOpsURL
    AgentPoolName: AgentPoolName

    // fqdn: fqdn
    // serverCertificateData: serverCertificateData
    // serverCertificatePassword: serverCertificatePassword
  }
}

/// Outputs ///

output resource_groups array = []
