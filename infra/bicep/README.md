# bicep/main.bicep

## Description

- item 1
- item 2


## Modules

| Symbolic Name | Source | Description |
| --- | --- | --- |
| acrpull_role_assignment | modules/role_assignment.bicep |  |
| acrpush_jumpbox_role_assignment | modules/role_assignment.bicep |  |
| acrpush_role_assignment | modules/role_assignment.bicep |  |
| aks | modules/aks.bicep |  |
| aks_role_assignment | modules/role_assignment.bicep |  |
| aks_role_assignment_owner | modules/role_assignment.bicep |  |
| bastion | modules/bastion.bicep |  |
| contributor_jumpbox_role_assignment | modules/role_assignment.bicep |  |
| cosmosdb | modules/cosmosdb.bicep |  |
| jumpbox | modules/jumpbox.bicep |  |
| keyvault | modules/keyvault.bicep |  |
| la_workspace | modules/la_workspace.bicep |  |
| network_contributor_role_assignment | modules/role_assignment.bicep |  |
| nsg | modules/nsg.bicep |  |
| registry | modules/registry.bicep |  |
| vnet | modules/vnet.bicep |  |

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| kv_existing | [Microsoft.KeyVault/vaults](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| AgentPoolName | string | Self hosted pool name |  |
| AzureDevOpsURL | string | Azure DevOps Organization URL |  |
| availability_zones | array | Availability Zone for redundancy |  |
| azurePAT | securestring | PAT azure devops |  |
| cosmosdb_admin_password | securestring | Password of the cosmosdb admin |  |
| cosmosdb_admin_password_secret_name | string | Name of the secret that will store the cosmosdb admin password |  |
| environment | string |  |  |
| jumpbox_admin_password | securestring | Password of the jumpbox admin |  |
| jumpbox_admin_password_secret_name | string | Name of the secret that will store the jumpbox admin password |  |
| jumpbox_admin_username | string | Username of the jumpbox admin |  |
| location | string |  |  |
| location_abbreviation | string |  |  |
| naming | object | Object of the Azure Naming module |  |
| rg_name | string | name of the resource group where the workload will be deployed |  |
| rg_tags | object | Tags to be applied on the resource group | {} |
| snet_agw_address_prefix | string | Address Prefix for Application Gateway Subnet |  |
| snet_aks_address_prefix | string | Address Prefix for Azure Kubernetes Service Subnet |  |
| snet_bastion_address_prefix | string | Address Prefix for Bastion Subnet |  |
| snet_cosmosdb_address_prefix | string | Address Prefix for CosmosDB Server Subnet |  |
| snet_shared_address_prefix | string | Address Prefix for Shared Resources Subnet |  |
| vnet_address_space | array | Address Space for Virtual Network |  |
| workload | string |  |  |

