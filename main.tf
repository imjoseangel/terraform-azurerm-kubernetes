#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

data "azurerm_client_config" "current" {}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}


#---------------------------------------------------------
# Kubernetes Creation or selection
#---------------------------------------------------------
resource "azurerm_kubernetes_cluster" "main" {
  name                            = format("%s-%s", var.prefix, lower(replace(var.name, "/[[:^alnum:]]/", "")))
  location                        = var.location
  resource_group_name             = local.resource_group_name
  node_resource_group             = var.node_resource_group
  dns_prefix                      = var.prefix
  api_server_authorized_ip_ranges = var.authorized_ips
  sku_tier                        = var.sku_tier
  private_cluster_enabled         = var.private_cluster_enabled

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.default_vm_size
    enable_auto_scaling = var.enable_auto_scaling
    vnet_subnet_id      = var.vnet_subnet_id
    type                = "VirtualMachineScaleSets"
    availability_zones  = var.availability_zones
    max_count           = var.max_default_node_count
    min_count           = var.min_default_node_count
    os_disk_size_gb     = var.os_disk_size_gb
  }

  linux_profile {
    admin_username = "k8s"

    ssh_key {
      key_data = file(var.public_ssh_key)
    }
  }
  addon_profile {
    oms_agent {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    ingress_application_gateway {
      enabled    = var.create_ingress
      gateway_id = var.gateway_id
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
  }

  role_based_access_control {
    enabled = true
  }

  tags = merge({ "ResourceName" = format("%s-%s", var.prefix, lower(replace(var.name, "/[[:^alnum:]]/", ""))) }, var.tags, )

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count, tags
    ]
  }

}
