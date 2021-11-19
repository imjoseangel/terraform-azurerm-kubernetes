# terraform-azurerm-kubernetes

[![Terraform](https://github.com/imjoseangel/terraform-azurerm-kubernetes/actions/workflows/terraform.yml/badge.svg)](https://github.com/imjoseangel/terraform-azurerm-kubernetes/actions/workflows/terraform.yml)

## Deploys a Kubernetes cluster on AKS with application gateway support. Monitoring support can be added through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service)

### NOTES

* A SystemAssigned identity will be created by default.
* Kubernetes Version is set to Current.
* Role Based Access Control is always enabled.

## Usage in Terraform 1.0

```terraform
data "azurerm_resource_group" "aksvnetrsg" {
  name = "vnetrsg-aks"
}

data "azurerm_virtual_network" "aksvnet" {
  name                = "vnet-aks"
  resource_group_name = data.azurerm_resource_group.aksvnetrsg.name
}

resource "azurerm_subnet" "akssubnet" {
  name                 = "subnet-aksnodes"
  resource_group_name  = data.azurerm_resource_group.aksvnetrsg.name
  virtual_network_name = data.azurerm_virtual_network.aksvnet.name
  address_prefixes     = ["10.100.10.0/24"]
}

module "aks" {
  source                               = "github.com/imjoseangel/terraform-azurerm-kubernetes"
  name                                 = "aksname"
  resource_group_name                  = "rsg-aks"
  location                             = "westeurope"
  prefix                               = "aksdns"
  sku_tier                             = "Free"
  create_resource_group                = true
  oms_agent_enabled                    = false
  enable_role_based_access_control     = true
  rbac_aad_managed                     = true
  rbac_aad_admin_group                 = ["group1", "group2"]
  availability_zones                   = ["1", "2"]
  private_cluster_enabled              = false # default value
  vnet_subnet_id                       = azurerm_subnet.akssubnet.id
  create_ingress                       = true # defaults to false
  gateway_id                           = azurerm_application_gateway.appgateway.id # id of the application gw for ingress
  enable_auto_scaling                  = true
  max_default_node_count               = 3
  min_default_node_count               = 1
  windows_node_pool_enabled            = true
  enable_windows_auto_scaling          = true
  max_default_windows_node_count       = 5
  min_default_windows_node_count       = 1
  linux_node_pool_enabled              = true
  enable_linux_auto_scaling            = true
  min_default_linux_node_count         = 3
  min_default_linux_node_count         = 1
}

resource "azurerm_role_assignment" "aks_resource_group" {
  scope                = data.azurerm_resource_group.aksvnetrsg.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.system_assigned_identity[0].principal_id
}
```

The module supports some outputs that may be used to configure a kubernetes
provider after deploying an AKS cluster.

```terraform
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}
```

## Authors

Originally created by [imjoseangel](http://github.com/imjoseangel)

## License

[MIT](LICENSE)
