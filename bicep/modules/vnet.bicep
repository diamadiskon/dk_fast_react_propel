// Parameters

@description('Name of the virtual network')
param vnet_name string

@description('Location of the virtual network')
param vnet_location string

@description('Address space of the virtual network')
param vnet_address_space array

@description('Name of the subnet where the private endpoints will reside')
param snet_shared_name string

@description('Address space of the subnet where the private endpoints will reside')
param snet_shared_address_prefix string

@description('Name of the subnet where the Bastion host will reside')
param snet_bastion_name string = 'AzureBastionSubnet'

@description('Address space of the subnet where the Bastion host will reside')
param snet_bastion_address_prefix string

@description('Id of Bastion`s nsg')
param nsgBastionId string

@description('Name of the subnet where the CosmosDB server integration will take place')
param snet_cosmosdb_name string

@description('Address space of the subnet where the CosmosDB server integration will take place')
param snet_cosmosdb_address_prefix string

@description('Name of the subnet where the AGW will reside')
param snet_agw_name string

@description('Address space of the subnet where the AGW will reside')
param snet_agw_address_prefix string

@description('Name of the subnet where the AKS will reside')
param snet_aks_name string

@description('Address space of the subnet where the AKS will reside')
param snet_aks_address_prefix string

// Resources

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnet_name
  location: vnet_location
  properties: {
    addressSpace: {
      addressPrefixes: vnet_address_space
    }
    subnets: [
      {
        name: snet_shared_name
        properties: {
          addressPrefix: snet_shared_address_prefix
        }
      }
      {
        name: snet_aks_name
        properties: {
          addressPrefix: snet_aks_address_prefix
          privateEndpointNetworkPolicies: 'Disabled' // required
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {// access to the ACR service endpoint without using public IP
              service: 'Microsoft.ContainerRegistry'
            }

          ]
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
      {
        name: snet_agw_name
        properties: {
          addressPrefix: snet_agw_address_prefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      {
        name: snet_cosmosdb_name
        properties: {
          addressPrefix: snet_cosmosdb_address_prefix
          privateEndpointNetworkPolicies: 'Disabled'

        }
      }
      {
        name: snet_bastion_name
        properties: {
          addressPrefix: snet_bastion_address_prefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: nsgBastionId // connect nsg rule to the subnet
          }
        }
      }
    ]
  }
}

// Outputs

output vnet_id string = virtualNetwork.id
output snet_shared_id string = virtualNetwork.properties.subnets[0].id
output snet_aks_id string = virtualNetwork.properties.subnets[1].id
output snet_agw_id string = virtualNetwork.properties.subnets[2].id
output snet_cosmosdb_id string = virtualNetwork.properties.subnets[3].id
output snet_bastion_id string = virtualNetwork.properties.subnets[4].id
