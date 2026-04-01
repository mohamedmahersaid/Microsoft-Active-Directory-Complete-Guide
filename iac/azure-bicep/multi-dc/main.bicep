// Minimal multi-DC lab template (two DCs in same VNet but separate subnets/zones)
// Parameters should be reviewed and adjusted for production use.

param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string
param dnsLabelPrefix string = 'adlab'
param vmSize string = 'Standard_B2ms'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'lab-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'dc01-subnet'
        properties: { addressPrefix: '10.10.1.0/24' }
      }
      {
        name: 'dc02-subnet'
        properties: { addressPrefix: '10.10.2.0/24' }
      }
      {
        name: 'mgmt-subnet'
        properties: { addressPrefix: '10.10.3.0/24' }
      }
    ]
  }
}

module nicDc1 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-dc01'
  params: {
    // omitted: reuse above pattern from single VM template
  }
  scope: resourceGroup()
  // Note: this module placeholder indicates where detailed NIC resource definitions should be added.
}

// For brevity: provide a sample and refer to iac/README for full deployable templates.
// Use this template as a starting point; adapt images, disk encryption, and managed identity per your policy.