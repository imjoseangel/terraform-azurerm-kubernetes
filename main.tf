#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#---------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  #ts:skip=AC_AZURE_0389 RSG lock should be skipped for now.
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

#---------------------------------------------------------
# SSH Key Creation or selection
#---------------------------------------------------------

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#---------------------------------------------------------
# Windows Username and Passowrd
#---------------------------------------------------------

resource "random_string" "username" {
  count   = var.windows_node_pool_enabled ? 1 : 0
  length  = 17
  special = false
}

resource "random_password" "password" {
  count  = var.windows_node_pool_enabled ? 1 : 0
  length = 17
}

#---------------------------------------------------------
# Read AD Group IDs
#---------------------------------------------------------

data "azuread_group" "main" {
  count        = length(var.rbac_aad_admin_group)
  display_name = var.rbac_aad_admin_group[count.index]
}

#---------------------------------------------------------
# Kubernetes Creation or selection
#---------------------------------------------------------
resource "azurerm_kubernetes_cluster" "main" {
  name                                = lower(var.name)
  location                            = local.location
  resource_group_name                 = local.resource_group_name
  node_resource_group                 = var.node_resource_group
  dns_prefix                          = (var.private_cluster_enabled && var.private_dns_zone_id != "None" && var.private_dns_zone_id != "System") ? null : var.prefix
  dns_prefix_private_cluster          = (var.private_cluster_enabled && var.private_dns_zone_id != "None" && var.private_dns_zone_id != "System") ? var.prefix : null
  sku_tier                            = var.sku_tier
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  local_account_disabled              = var.local_account_disabled
  run_command_enabled                 = var.run_command_enabled
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  automatic_upgrade_channel           = var.automatic_upgrade_channel
  node_os_upgrade_channel             = var.node_os_upgrade_channel
  http_application_routing_enabled    = false
  azure_policy_enabled                = var.enable_azure_policy
  image_cleaner_enabled               = var.enable_image_cleaner
  image_cleaner_interval_hours        = var.image_cleaner_interval_hours
  workload_identity_enabled           = var.oidc_issuer_enabled ? var.enable_workload_identity : false

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      name                         = substr(lower(var.node_pool_name), 0, 12)
      node_count                   = var.node_count
      vm_size                      = var.default_vm_size
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      temporary_name_for_rotation  = "temp"
      vnet_subnet_id               = var.vnet_subnet_id
      auto_scaling_enabled         = var.enable_auto_scaling
      max_count                    = null
      min_count                    = null
      zones                        = var.availability_zones
      max_pods                     = var.max_default_pod_count
      type                         = "VirtualMachineScaleSets"
      only_critical_addons_enabled = var.system_only
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      name                         = substr(lower(var.node_pool_name), 0, 12)
      vm_size                      = var.default_vm_size
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      temporary_name_for_rotation  = "temp"
      vnet_subnet_id               = var.vnet_subnet_id
      auto_scaling_enabled         = var.enable_auto_scaling
      max_count                    = var.max_default_node_count
      min_count                    = var.min_default_node_count
      zones                        = var.availability_zones
      max_pods                     = var.max_default_pod_count
      type                         = "VirtualMachineScaleSets"
      only_critical_addons_enabled = var.system_only
    }
  }

  linux_profile {
    admin_username = "k8s"

    ssh_key {
      key_data = replace(var.public_ssh_key == "" ? tls_private_key.ssh.public_key_openssh : var.public_ssh_key, "\n", "")
    }
  }

  dynamic "oms_agent" {
    for_each = var.oms_agent_enabled ? [true] : []
    content {
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main[0].id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_azure_keyvault_secrets_provider ? [true] : []
    content {
      secret_rotation_enabled  = var.secret_rotation_enabled
      secret_rotation_interval = var.secret_rotation_enabled ? var.secret_rotation_interval : null
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = (var.create_ingress && var.gateway_id != null) ? [true] : []
    content {
      gateway_id = var.gateway_id
    }
  }

  dynamic "api_server_access_profile" {
    for_each = var.enable_api_server_access_profile ? [true] : []
    content {
      authorized_ip_ranges = var.authorized_ips
    }
  }

  dynamic "windows_profile" {
    for_each = var.windows_node_pool_enabled ? [true] : []
    content {
      admin_password = random_password.password[0].result
      admin_username = random_string.username[0].result
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.user_assigned_identity_id
  }

  kubelet_identity {
    client_id                 = var.kubelet_client_id
    object_id                 = var.kubelet_object_id
    user_assigned_identity_id = var.kubelet_user_assigned_identity_id
  }

  network_profile {
    #ts:skip=accurics.azure.NS.382 This rule should be skipped for now.
    load_balancer_sku   = length(var.availability_zones) == 0 && var.windows_node_pool_enabled == false ? var.load_balancer_sku : "standard"
    network_plugin      = var.windows_node_pool_enabled || var.network_plugin_mode == "overlay" || var.network_policy == "cilium" ? "azure" : var.network_plugin
    network_policy      = var.network_policy
    network_data_plane  = var.network_policy == "cilium" ? "cilium" : "azure"
    outbound_type       = var.private_cluster_enabled ? "userDefinedRouting" : var.outbound_type
    dns_service_ip      = var.dns_service_ip
    service_cidr        = var.service_cidr
    pod_cidr            = var.network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? var.pod_cidr : null
    network_plugin_mode = var.network_policy == "cilium" ? "overlay" : var.network_plugin_mode
  }

  storage_profile {
    blob_driver_enabled = var.enable_blob_driver
    disk_driver_enabled = var.enable_disk_driver
    file_driver_enabled = var.enable_file_driver
  }

  auto_scaler_profile {
    balance_similar_node_groups = var.balance_similar_node_groups
  }

  workload_autoscaler_profile {
    keda_enabled                    = var.enable_keda
    vertical_pod_autoscaler_enabled = var.enable_vpa
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
    content {
      admin_group_object_ids = length(var.rbac_aad_admin_group) == 0 ? var.rbac_aad_admin_group : data.azuread_group.main[*].id
      azure_rbac_enabled     = var.azure_rbac_enabled
    }
  }

  tags = merge({ "ResourceName" = lower(var.name) }, var.tags, )

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count, default_node_pool[0].upgrade_settings, tags, linux_profile[0].ssh_key, azure_active_directory_role_based_access_control[0].admin_group_object_ids
    ]
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "windows" {
  count                        = var.windows_node_pool_enabled ? 1 : 0
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.main.id
  name                         = substr(lower(var.windows_pool_name), 0, 6)
  node_count                   = var.enable_windows_auto_scaling == false ? var.windows_node_count : null
  vm_size                      = var.windows_vm_size
  os_disk_size_gb              = var.windows_os_disk_size_gb
  os_disk_type                 = var.windows_os_disk_type
  vnet_subnet_id               = var.vnet_subnet_id
  auto_scaling_enabled         = var.enable_windows_auto_scaling
  max_count                    = var.enable_windows_auto_scaling ? var.max_default_windows_node_count : null
  min_count                    = var.enable_windows_auto_scaling ? var.min_default_windows_node_count : null
  zones                        = var.availability_zones
  max_pods                     = var.max_default_windows_pod_count
  node_taints                  = ["os=windows:NoSchedule"]
  proximity_placement_group_id = var.windows_proximity_placement_group_id
  os_type                      = "Windows"
  os_sku                       = "Windows2022"
}

resource "azurerm_kubernetes_cluster_node_pool" "linux" {
  count                        = var.linux_node_pool_enabled ? 1 : 0
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.main.id
  name                         = substr(lower(var.linux_pool_name), 0, 12)
  node_count                   = var.enable_linux_auto_scaling == false ? var.linux_node_count : null
  vm_size                      = var.linux_vm_size
  os_disk_size_gb              = var.linux_os_disk_size_gb
  os_disk_type                 = var.linux_os_disk_type
  os_sku                       = var.os_sku
  vnet_subnet_id               = var.linux_vnet_subnet_id
  auto_scaling_enabled         = var.enable_linux_auto_scaling
  max_count                    = var.enable_linux_auto_scaling ? var.max_default_linux_node_count : null
  min_count                    = var.enable_linux_auto_scaling ? var.min_default_linux_node_count : null
  zones                        = var.availability_zones
  max_pods                     = var.max_default_linux_pod_count
  proximity_placement_group_id = var.linux_proximity_placement_group_id
  os_type                      = "Linux"
}


data "azurerm_log_analytics_workspace" "main" {
  count               = var.oms_agent_enabled ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group
}
