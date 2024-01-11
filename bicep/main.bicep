targetScope = 'resourceGroup'

param location string
param location_abbreviation string
param workload string
param environment string

/// Parameters ///

@description('Tags to be applied on the resource group')
param rg_tags object = {}

@description('Object of the Azure Naming module')
param naming object

@description('name of the resource group where the workload will be deployed')
param rg_name string

@description('Availability Zone for redundancy')
param availability_zones array

@description('Username of the jumpbox admin')
param jumpbox_admin_username string

@description('Password of the jumpbox admin')
@secure()
param jumpbox_admin_password string

@description('Password of the cosmosdb admin')
@secure()
param cosmosdb_admin_password string

@description('Name of the secret that will store the cosmosdb admin password')
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

@description('Address Prefix for CosmosDB Server Subnet')
param snet_cosmosdb_address_prefix string

@description('Address Prefix for Shared Resources Subnet')
param snet_shared_address_prefix string

@description('Address Prefix for Bastion Subnet')
param snet_bastion_address_prefix string

@secure()
@description('PAT azure devops')
param azurePAT string

@description('Azure DevOps Organization URL')
param AzureDevOpsURL string

@description('Self hosted pool name')
param AgentPoolName string

// Modules

// Networking Resources

module nsg 'modules/nsg.bicep' = {
  name: 'nsg-deployment'
  params: {
    suffix: suffix
    location: location
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    vnet_name: 'vnet-${suffix}'
    vnet_address_space: vnet_address_space
    vnet_location: location
    snet_agw_name: 'snet-agw-${suffix}'
    snet_agw_address_prefix: snet_agw_address_prefix
    snet_cosmosdb_name: 'snet-cosmosdb-${suffix}'
    snet_cosmosdb_address_prefix: snet_cosmosdb_address_prefix
    snet_aks_name: 'snet-aks-${suffix}'
    snet_aks_address_prefix: snet_aks_address_prefix
    snet_shared_name: 'snet-shared-${suffix}'
    snet_shared_address_prefix: snet_shared_address_prefix
    snet_bastion_name: 'AzureBastionSubnet'
    snet_bastion_address_prefix: snet_bastion_address_prefix
    nsgBastionId: nsg.outputs.bastionNsgId
  }
}

// Key Vault

module keyvault 'modules/keyvault.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'kv-${workload}-deployment'
  params: {
    name: kv_name
    location: location
    sku_name: 'standard'

    soft_delete_enabled: true
    purge_protection_enabled: true
    enabled_for_template_deployment: true

    enable_rbac_authorization: false

    jumpbox_admin_password_secret_name: jumpbox_admin_password_secret_name
    jumpbox_admin_password_secret_value: jumpbox_admin_password

    cosmosdb_admin_password_secret_name: cosmosdb_admin_password_secret_name
    cosmosdb_admin_password_secret_value: cosmosdb_admin_password

    pep_name: 'pep-kv-${suffix}'
    pep_location: location
    pep_subnet_id: vnet.outputs.snet_shared_id

    vnet_id: vnet.outputs.vnet_id

    workspace_id: la_workspace.outputs.log_workspace_id
  }
}

resource kv_existing 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kv_name
}

// vm

module jumpbox 'modules/jumpbox.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'jumpbox-${workload}-deployment'
  params: {
    name: naming.virtualMachine.name
    location: location
    availability_zones: [ '1' ]
    size: 'Standard_D2_v2'
    extensionName: 'setup-agent-extension'
    admin_username: jumpbox_admin_username
    admin_password: kv_existing.getSecret(jumpbox_admin_password_secret_name)
    image_publisher: 'Canonical'
    image_offer: 'UbuntuServer'
    image_sku: '18.04-LTS'
    image_version: 'latest'

    nic_name: 'nic-vm-jumpbox'
    nic_location: location

    jumpbox_subnet_id: vnet.outputs.snet_shared_id

    scriptName: 'install-agent.sh'
    scriptUrl: 'https://raw.githubusercontent.com/diamadiskon/Scripts/main/install-agent.sh'
    nsgVmId: nsg.outputs.vmNsgId
    AzureDevOpsPAT: azurePAT
    AzureDevOpsURL: AzureDevOpsURL
    AgentPoolName: AgentPoolName
  }
  dependsOn: [
    keyvault
  ]
}

//Role assignment for jumpbox
// module contributor_role_assignment 'modules/role_assignment.bicep' = {
//   scope: resourceGroup(rg_name)
//   name: 'contributor-role-assignment-${workload}-deployment'
//   params: {
//     built_in_role_type: 'Contributor'
//     principal_id: jumpbox.outputs.vm_identity_principal_id
//   }
// }

module bastion 'modules/bastion.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'bastion-${workload}-deployment'
  params: {
    name: naming.bastionHost.name
    location: location
    sku: 'Standard'

    pip_name: 'pip-bas-${suffix}'
    pip_location: location
    pip_sku_name: 'Standard'
    pip_allocation_method: 'Static'

    subnet_id: vnet.outputs.snet_bastion_id
  }
}

// ACR

module registry 'modules/registry.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'cr-${workload}-deployment'
  params: {
    name: naming.containerRegistry.nameUnique
    location: location
    sku: 'Premium'

    policy_status: 'enabled'
    policy_type: 'Notary'

    admin_enabled: false
    public_network_access: 'Disabled'
    zone_redundancy: 'Disabled'

    pep_name: 'pep-cr-${suffix}'
    pep_location: location
    acr_pep_subnet_id: vnet.outputs.snet_shared_id

    vnet_id: vnet.outputs.vnet_id
  }
}

// AKS 

module aks 'modules/aks.bicep' = {
  name: 'aks-deployment'
  params: {
    aksName: 'aks-${suffix}'
    location: location
    version: '1.28.0'
    aksSubnetId: vnet.outputs.snet_aks_id
    availability_zones: availability_zones
    log_workspace_id: la_workspace.outputs.log_workspace_id
  }
  dependsOn: [
    vnet
  ]
}

// application gateway

// module applicationGateway 'modules/agw.bicep' = {
//   name: 'agw-${workload}-deployment'
//   params: {
//     agName: 'agw-${workload}-we'
//     agSubnetId: vnet.outputs.snet_agw_id
//     cdfPublicIpName: 'pip-cdf-${workload}-we'
//     agPrivateIpAddress: '10.1.3.6'
//     availability_zones: availability_zones
//     tags: rg_tags
//     location: location
//   }
//   dependsOn: [
//     vnet
//   ]
// }

// DB server

module cosmosdb 'modules/cosmosdb.bicep' = {
  name: 'cosmosdb-${workload}-deployment'
  params: {
    location: location
    tableName: 'health-dashboard-table'
    primaryRegion: 'westeurope'
    secondaryRegion: 'northeurope'
  }
}

// Log analytics

module la_workspace 'modules/la_workspace.bicep' = {
  name: 'log-${workload}-deployment'
  params: {
    location: location
    logAnalyticsWorkspace: naming.logAnalyticsWorkspace.name
  }
}

/// Role assignments ///

// Role assignments for AKS
module aks_role_assignment 'modules/role_assignment.bicep' = {
  name: 'aks-role-assignment-deployment'
  params: {
    built_in_role_type: 'Contributor'
    principal_id: aks.outputs.aksManagedIdentityPrincipalId
  }
  dependsOn: [
    aks
  ]
}

module aks_role_assignment_owner 'modules/role_assignment.bicep' = {
  name: 'aks-role-assignment-owner-deployment'
  params: {
    built_in_role_type: 'Owner'
    principal_id: aks.outputs.aksManagedIdentityPrincipalId
  }
  dependsOn: [
    aks
  ]
}

module acrpull_role_assignment 'modules/role_assignment.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'acrpull-role-assignment-${workload}-deployment'
  params: {
    built_in_role_type: 'AcrPull'
    principal_id: aks.outputs.aksManagedIdentityPrincipalId
  }
  dependsOn: [
    aks
  ]
}

module acrpush_role_assignment 'modules/role_assignment.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'acrpush-role-assignment-${workload}-deployment'
  params: {
    built_in_role_type: 'AcrPush'
    principal_id: aks.outputs.aksManagedIdentityPrincipalId
  }
  dependsOn: [
    aks
  ]
}

module network_contributor_role_assignment 'modules/role_assignment.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'network-contributor-role-assignment-${workload}-deployment'
  params: {
    built_in_role_type: 'NetworkContributor'
    principal_id: aks.outputs.aksManagedIdentityPrincipalId
  }
  dependsOn: [
    aks
  ]
}

// Role assignments for Jumpbox

module contributor_jumpbox_role_assignment 'modules/role_assignment.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'jump-role-assignment-deployment'
  params: {
    built_in_role_type: 'Owner'
    principal_id: jumpbox.outputs.vm_identity_principal_id
  }
  dependsOn: [
    jumpbox
  ]
}

module acrpush_jumpbox_role_assignment 'modules/role_assignment.bicep' = {
  scope: resourceGroup(rg_name)
  name: 'acrpush-role-assignment-deployment'
  params: {
    built_in_role_type: 'AcrPush'
    principal_id: jumpbox.outputs.vm_identity_principal_id
  }
  dependsOn: [
    jumpbox
  ]
}

/// Variables ///

var kv_name = '${naming.keyVault.nameUnique}'
var suffix = '${workload}-${environment}-${location_abbreviation}'
