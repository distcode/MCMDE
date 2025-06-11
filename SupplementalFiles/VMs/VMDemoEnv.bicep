param Prefix string = 'vmd'
param DeployVNets bool = false
param DeployVMs bool = false

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: 'trgKeyVaultPremium'
  scope: resourceGroup('RG-Mgmt')
}

module baseVNet1 './modules/BaseVNet1.bicep' = if (DeployVNets) {
  name: 'baseVNetDeployment'
  params: {
    Prefix: Prefix
  }
}

module baseVM './modules/BaseVM.bicep' = if (DeployVMs) {
  name: 'baseVMDeployment'
  dependsOn: [
    baseVNet1
  ]
  params: {
    Prefix: Prefix
    adminP: kv.getSecret('StdVMPwd', '4b5f45e5bad64328a097b5f93b2c4fe7')
  }
}

