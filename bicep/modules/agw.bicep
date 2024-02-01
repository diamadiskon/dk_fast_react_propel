// Creates an Application Gateway

// Parameters
@description('Azure region of the deployment')
param location string

@description('Tags to add to the resources')
param tags object

@description('Application gateway name')
param agName string

@description('CDF public ip name')
param cdfPublicIpName string

@description('Application gateway subnet name')
param agSubnetId string

@description('Availability Zone for redundancy')
param availability_zones array = []

@description('Private ip address for AG frontend configuration')
param agPrivateIpAddress string

// Variables
var frontEndPublicIpConfigurationName = 'appGwPublicFrontendIp'
var frontEndPrivateIpConfigurationName = 'appGwPrivateFrontendIp'
var applicationGatewayId = resourceId('Microsoft.Network/applicationGateways', '${agName}')

// Resources
resource cdfPublicIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: cdfPublicIpName
  location: location
  tags: tags
  zones: availability_zones
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: agName
  location: location
  tags: tags
  zones: availability_zones
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: agSubnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontEndPublicIpConfigurationName
        properties: {
          publicIPAddress: {
            id: cdfPublicIp.id
          }
        }
      }

      {
        name: frontEndPrivateIpConfigurationName
        properties: {
          privateIPAddress: agPrivateIpAddress
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: agSubnetId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port_443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bp'
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'http_set_cdf'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 180
        }
      }
      {
        name: 'https_set_cdf'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 180
        }
      }
    ]
    httpListeners: [
      {
        name: 'listener_cdf_80'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGatewayId}/frontendIPConfigurations/${frontEndPublicIpConfigurationName}'
          }
          frontendPort: {
            id: '${applicationGatewayId}/frontendPorts/port_80'
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'routing_rule_cdf'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGatewayId}/httpListeners/listener_cdf_80'
          }
          backendAddressPool: {
            id: '${applicationGatewayId}/backendAddressPools/bp'
          }
          backendHttpSettings: {
            id: '${applicationGatewayId}/backendHttpSettingsCollection/http_set_cdf'
          }
        }
      }
    ]
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 2
      maxCapacity: 10
    }
    firewallPolicy: {
      id: AppGW_AppFW_Pol.id
    }
  }
}

resource AppGW_AppFW_Pol 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-08-01' = {
  name: '${agName}-waf'
  location: location
  properties: {
    customRules: []
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: 'Prevention'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.1'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
  }
}

output applicationGatewayId string = applicationGateway.id
output applicationGatewayName string = applicationGateway.name

output applicationGatewayPublicIp string = cdfPublicIp.properties.ipAddress
