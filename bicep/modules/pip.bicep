// Parameters
@description('Azure region of the deployment')
param location string
param name string
param allocationMethod string

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: name
  location: location
  properties: {
    publicIPAllocationMethod: allocationMethod
    publicIPAddressVersion: 'IPv4'
  }
  zones: [
    '1'

  ]
  sku: {
    name: 'Standard'
  }

}

output publicIpOutput string = publicIp.properties.ipAddress
