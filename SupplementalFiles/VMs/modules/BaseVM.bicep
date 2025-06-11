@maxLength(4)
param Prefix string = 'vmd'
// param DeployNVA bool = false
@maxValue(5)
@minValue(1)
param CountSrv int = 2
@maxValue(5)
@minValue(1)
param CountCli int = 1
param Location string = resourceGroup().location
param VMSize string = 'Standard_B2as_v2' // 'Standard_B2s'
param adminU string = 'localadmin'
@secure()
param adminP string

resource WinVMJumpHost 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: '${Prefix}-VM-Jump'
  location: Location
  properties: {
    hardwareProfile: {
      vmSize: VMSize
    }
    osProfile: {
      computerName: '${Prefix}-VM-Jump'
      adminUsername: adminU
      adminPassword: adminP
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        name: '${Prefix}-Disk-VM-JumpHost'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NICJumpHost.id
        }
      ]
    }
  }
}
resource WinVMServer 'Microsoft.Compute/virtualMachines@2024-07-01' = [
  for i in range(1, CountSrv): {
    name: '${Prefix}-VMSrv-${i}'
    location: Location
    dependsOn: [
      NICSrv
    ]
    properties: {
      hardwareProfile: {
        vmSize: VMSize
      }
      osProfile: {
        computerName: '${Prefix}-VMSrv-${i}'
        adminUsername: adminU
        adminPassword: adminP
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2025-datacenter-smalldisk-g2'
          version: 'latest'
        }
        osDisk: {
          name: '${Prefix}-Disk-VMSrv-${i}'
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId('Microsoft.Network/networkinterfaces', '${Prefix}-NIC-VMSrv-${i}')
          }
        ]
      }
    }
  }
]
resource WinVMClient 'Microsoft.Compute/virtualMachines@2024-07-01' = [
  for i in range(1, CountCli): {
    name: '${Prefix}-VMCli-${i}'
    location: Location
    dependsOn: [
      NICSrv
    ]
    properties: {
      hardwareProfile: {
        vmSize: VMSize
      }
      osProfile: {
        computerName: '${Prefix}-VMCli-${i}'
        adminUsername: adminU
        adminPassword: adminP
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsDesktop'
          offer: 'Windows-11'
          sku: 'win11-24h2-entn'
          version: 'latest'
        }
        osDisk: {
          name: '${Prefix}-Disk-VMCli-${i}'
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId('Microsoft.Network/networkinterfaces', '${Prefix}-NIC-VMCli-${i}')
          }
        ]
      }
    }
  }
]

resource NICJumpHost 'Microsoft.Network/networkInterfaces@2024-03-01' = {
  name: '${Prefix}-NIC-VM-JumpHost'
  location: Location
  properties: {
    networkSecurityGroup: {
      id: NSGDefault.id
    }
    ipConfigurations: [
      {
        name: 'MainConfiguration'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: VNetHubSubnetCentralResources.id
          }
          publicIPAddress: { id: PubIPJumpHost.id }
        }
      }
    ]
  }
}

resource NICSrv 'Microsoft.Network/networkInterfaces@2024-03-01' = [
  for i in range(1, CountSrv): {
    name: '${Prefix}-NIC-VMSrv-${i}'
    location: Location
    dependsOn: [
      PubIPServers
    ]
    properties: {
      networkSecurityGroup: {
        id: NSGDefault.id
      }
      ipConfigurations: [
        {
          name: 'MainConfiguration'
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: VNetHubSubnetServers.id
            }
            publicIPAddress: { id: resourceId('Microsoft.Network/publicIPAddresses', '${Prefix}-PubIP-VMSrv-${i}') }
          }
        }
      ]
    }
  }
]

resource NICCli 'Microsoft.Network/networkInterfaces@2024-03-01' = [
  for i in range(1, CountCli): {
    name: '${Prefix}-NIC-VMCli-${i}'
    location: Location
    dependsOn: [
      // PubIPClients
    ]
    properties: {
      // networkSecurityGroup: {
        // id: NSGDefault.id
      // }
      ipConfigurations: [
        {
          name: 'MainConfiguration'
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: VNetHubSubnetClients.id
            }
            // publicIPAddress: { id: resourceId('Microsoft.Network/publicIPAddresses', '${Prefix}-PubIP-VMCli-${i}') }
          }
        }
      ]
    }
  }
]

resource PubIPJumpHost 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: '${Prefix}-PubIP-JumpHost'
  location: Location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    deleteOption: 'Delete'
  }
}

resource PubIPServers 'Microsoft.Network/publicIPAddresses@2024-03-01' = [
  for i in range(1, CountSrv): {
    name: '${Prefix}-PubIP-VMSrv-${i}'
    location: Location
    sku: { name: 'Standard' }
    properties: {
      publicIPAllocationMethod: 'Static'
      publicIPAddressVersion: 'IPv4'
      deleteOption: 'Delete'
    }
  }
]

/*
resource PubIPClients 'Microsoft.Network/publicIPAddresses@2024-03-01' = [
  for i in range(1, CountCli): {
    name: '${Prefix}-PubIP-VMCli-${i}'
    location: Location
    sku: { name: 'Standard' }
    properties: {
      publicIPAllocationMethod: 'Static'
      publicIPAddressVersion: 'IPv4'
      deleteOption: 'Delete'
    }
  }
]
*/

resource NSGDefault 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: '${Prefix}-NSG-Default'
  location: Location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          description: 'RDP Connections Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 510
          direction: 'Inbound'
        }
      }
      {
        name: 'SSH'
        properties: {
          description: 'SSH Connections Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 520
          direction: 'Inbound'
        }
      }
      {
        name: 'RemotePowerShell'
        properties: {
          description: 'WinRM - Remote PowerShell'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5986-5986'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 530
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource VNetHub 'Microsoft.Network/virtualNetworks@2024-03-01' existing = {
  name: '${Prefix}-VNet-Hub-Ext'
}
resource VNetHubSubnetCentralResources 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: VNetHub
  name: 'CentralResources'
}
resource VNetHubSubnetServers 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  parent: VNetHub  
  name: 'Servers'
}
resource VNetHubSubnetClients 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  parent: VNetHub
  name: 'Clients'
}

