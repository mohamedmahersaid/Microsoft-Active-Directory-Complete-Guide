param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string

// Minimal lab: vnet, subnet, nic, ubuntu management VM and a Windows DC VM (Windows eval)
// NOTE: For production you MUST NOT use adminPassword directly; use Key Vault or managed identity.

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'lab-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'dc-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'mgmt-subnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

resource nicDC 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'dc-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}

resource vmDC 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'dc-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: 'DC1'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicDC.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
  }
}