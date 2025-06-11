@maxLength(4)
param Prefix string = 'vmd'

var Location = resourceGroup().location

resource VNetHub 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: '${Prefix}-VNet-Hub-Ext'
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'CentralResources'
        properties: {
          addressPrefix: '10.20.0.0/24'
        }
      }
      {
        name: 'Servers'
        properties: {
          addressPrefix: '10.20.1.0/24'
        }
      }
      {
        name: 'Clients'
        properties: {
          addressPrefix: '10.20.2.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.20.90.0/24'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.20.91.0/24'
        }
      }
    ]
  }
}
