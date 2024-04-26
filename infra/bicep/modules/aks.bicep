// Parameters

@description('Location')
param location string

@description('AKS Name')
param aksName string

@description('Resource ID for the Azure Kubernetes Service subnet')
param aksSubnetId string

@description('Kubernetes Version')
param version string

@description('Availability Zone for redundancy')
param availability_zones array

@description('ID of the Log Analytics Workspace')
param log_workspace_id string

// Resources

resource aks 'Microsoft.ContainerService/managedClusters@2023-05-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
  properties: {
    kubernetesVersion: version
    dnsPrefix: '${aksName}-dns'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 1
        vmSize: 'Standard_D2s_v3'
        osType: 'Linux'
        mode: 'System'
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: false
        enableNodePublicIP: false
        vnetSubnetID: aksSubnetId
        availabilityZones: availability_zones
      }
      {
        name: 'linuxpool'
        vmSize: 'Standard_D2s_v3'
        osType: 'Linux'
        mode: 'System'
        count: 1
        minCount: 1
        maxCount: 2
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: true
        enableNodePublicIP: false
        vnetSubnetID: aksSubnetId
        availabilityZones: availability_zones
      }
    ]
    networkProfile: {
      networkPlugin: 'kubenet'
      networkPolicy: 'calico'
      loadBalancerSku: 'Standard'
      // outboundType: 'userDefinedRouting'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }
    addonProfiles: {
      omsagent: {
        config: {
          logAnalyticsWorkspaceResourceID: log_workspace_id
        }
        enabled: true
      }
      azurepolicy: {
        enabled: true
        config: {
          version: 'v2'
        }
      }
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
        }
      }
    }
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: log_workspace_id
        securityMonitoring: {
          enabled: true
        }
      }
    }
  }
}

resource aksDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: aks
  name: '${aksName}-diagnostic-settings'
  properties: {
    workspaceId: log_workspace_id
    logs: [
      {
        category: 'kube-audit'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'kube-audit-admin'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'guard'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'kube-apiserver'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'kube-controller-manager'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'kube-scheduler'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'cluster-autoscaler'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]
  }
}

// Outputs 

output aksName string = aks.name
output aksResourceId string = aks.id
output aksManagedIdentityPrincipalId string = aks.identity.principalId
