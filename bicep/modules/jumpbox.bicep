// Parameters

@description('Name of the vm')
param name string

@description('Location of the vm')
param location string

@description('Availability Zone for vm redundancy')
param availability_zones array

@description('Name of VM extension')
param extensionName string

@description('Size of the vm')
param size string

@description('Publisher of the image')
param image_publisher string

@description('Specifies the offer of the platform image or marketplace image used to create the vm')
param image_offer string

@description('SKU of the image')
param image_sku string

@description('Specifies the version of the platform image or marketplace image used to create the vm')
param image_version string = 'latest'

@description('Username for vm admin')
param admin_username string

@description('Password for vm admin')
@secure()
param admin_password string

@description('Name of the vm nic')
param nic_name string

@description('Location of the vm nic')
param nic_location string

@description('ID of the jumpbox subnet')
param jumpbox_subnet_id string

@description('Url of the public script for custom script extension')
param scriptUrl string

@description('Name of the script for custom script extension')
param scriptName string

@description('Nsg of vm')
param nsgVmId string

@description('Name of agent pool')
param AgentPoolName string

@description('Azure Devops Url')
param AzureDevOpsURL string

@secure()
@description('Azure DevOps PAT')
param AzureDevOpsPAT string

// Resources

resource nic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: nic_name
  location: nic_location
  properties: {
    ipConfigurations: [
      {
        name: 'nic-vm-ip-configuration'
        properties: {
          subnet: {
            id: jumpbox_subnet_id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgVmId
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: name
  location: location
  zones: availability_zones
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: size
    }

    storageProfile: {
      osDisk: {
        osType: 'Linux'
        name: '${name}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 100
      }
      dataDisks: []
      imageReference: {
        publisher: image_publisher
        offer: image_offer
        sku: image_sku
        version: image_version
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }

    osProfile: {
      computerName: name
      adminUsername: admin_username
      adminPassword: admin_password

      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      customData: loadFileAsBase64('../../.github/scripts/setup_jumpbox.tpl')

    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vmextensionDocker 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: vm
  name: 'agentDocker'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'DockerExtension'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

// resource customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
//   parent: vm
//   name: 'initial-config'
//   location: location
//   properties: {
//     publisher: 'Microsoft.Azure.Extensions'
//     type: 'CustomScript'
//     typeHandlerVersion: '2.1'
//     autoUpgradeMinorVersion: true
//     protectedSettings: {
//       fileUris: [
//         '${scriptUrl}'
//       ]
//       commandToExecute: 'sh ${scriptName} ${admin_username} ${AzureDevOpsURL} ${AzureDevOpsPAT} ${AgentPoolName}'
//     }
//   }
// }

// Outputs

output vm_id string = vm.id
output vm_identity_principal_id string = vm.identity.principalId
