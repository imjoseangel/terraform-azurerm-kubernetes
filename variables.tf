variable "name" {
  description = "Name of Azure Kubernetes service."
  type        = string
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
  type        = bool
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-demo-westeurope-01"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
  type        = string
}

variable "prefix" {
  description = "The DNS prefix for the Cluster"
  type        = string
  default     = null
}

variable "default_vm_size" {
  description = "The size of the Virtual Machine, such as Standard_D2ds_v5"
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "availability_zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = []
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Free"
}

variable "private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = true
}

variable "private_cluster_public_fqdn_enabled" {
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added."
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning."
  type        = string
  default     = null
}

variable "authorized_ips" {
  description = "A list of IP addresses to allow to connect to the cluster."
  type        = list(string)
  default     = null
}

variable "max_default_node_count" {
  description = "(Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "min_default_node_count" {
  description = "(Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "node_resource_group" {
  description = "(Optional) The name of the Resource Group where the Kubernetes Nodes should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "node_pool_name" {
  description = "The default Azure AKS nodepool name."
  type        = string
  default     = "default"
}

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "(Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico, azure and cilium"
  type        = string
  default     = null
}

variable "network_plugin_mode" {
  description = "(Optional) Specifies the network plugin mode used for building the Kubernetes network. Possible value is overlay."
  type        = string
  default     = "overlay"
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  type        = string
  default     = ""
}

variable "node_count" {
  description = "The number of Nodes that should exist in the Pool. Please set `node_count` `null` while `enable_auto_scaling` is `true` to avoid possible `node_count` changes."
  type        = number
  default     = null
}

variable "enable_auto_scaling" {
  description = "Enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "system_only" {
  description = "(Optional) Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule taint."
  type        = bool
  default     = true
}

variable "oms_agent_enabled" {
  description = "Deploy the OMS Agent to this Kubernetes Cluster"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_name" {
  description = "(Optional) The name of the Analytics workspace"
  type        = string
  default     = null
}

variable "log_analytics_resource_group" {
  description = "The resource group name of the Analytics workspace"
  type        = string
  default     = null
}

variable "create_ingress" {
  description = "Deploy the Application Gateway ingress controller to this Kubernetes Cluster"
  type        = bool
  default     = false
}

variable "gateway_id" {
  description = "(Optional) The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster"
  type        = string
  default     = null
}

variable "vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "linux_vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes Linux Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "load_balancer_sku" {
  description = "(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are Basic and Standard. Defaults to Standard."
  type        = string
  default     = "Standard"
}

variable "os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 50
}

variable "os_disk_type" {
  description = "The type of disk which should be used for the Operating System."
  type        = string
  default     = "Ephemeral"
}

variable "os_sku" {
  description = "(Optional) Specifies the OS SKU used by the agent pool. Possible values are AzureLinux, Ubuntu, Windows2019 and Windows2022"
  type        = string
  default     = "AzureLinux"
}

variable "enable_image_cleaner" {
  description = "(Optional) Specifies whether Image Cleaner is enabled."
  type        = bool
  default     = true
}

variable "image_cleaner_interval_hours" {
  description = "(Optional) Specifies the interval in hours when images should be cleaned up. Defaults to 48."
  type        = number
  default     = 48
}

variable "enable_workload_identity" {
  description = "(Optional) Specifies whether Azure AD Workload Identity should be enabled for the Cluster. Defaults to true."
  type        = bool
  default     = true
}

variable "enable_keda" {
  description = "(Optional) Specifies whether KEDA Autoscaler can be used for workloads."
  type        = bool
  default     = true
}

variable "enable_vpa" {
  description = "(Optional) Specifies whether Vertical Pod Autoscaler should be enabled."
  type        = bool
  default     = true
}

variable "enable_role_based_access_control" {
  description = "Enable Role Based Access Control."
  type        = bool
  default     = true
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy for Kubernetes Add On."
  type        = bool
  default     = false
}

variable "balance_similar_node_groups" {
  description = "Detect similar node groups and balance the number of nodes between them. Defaults to false."
  type        = bool
  default     = false
}

variable "rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = bool
  default     = true
}

variable "azure_rbac_enabled" {
  description = "(Optional) Is Role Based Access Control based on Azure AD enabled?"
  type        = bool
  default     = true
}

variable "rbac_aad_admin_group" {
  description = "List of groups with admin access."
  type        = list(string)
  default     = []
}

variable "windows_node_pool_enabled" {
  description = "Enable Windows node pool"
  type        = bool
  default     = false
}

variable "windows_pool_name" {
  description = "The name of the Windows node Pool (A Windows Node Pool cannot have a name longer than 6 characters.)"
  type        = string
  default     = "wnpool"
}

variable "windows_vm_size" {
  description = "The size of the Windows Virtual Machine, such as Standard_D2ds_v5"
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "windows_node_count" {
  description = "The number of Nodes that should exist in the Pool. Please set `node_count` `null` while `enable_auto_scaling` is `true` to avoid possible `node_count` changes."
  type        = number
  default     = null
}

variable "windows_os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 50
}

variable "windows_os_disk_type" {
  description = "The type of disk which should be used for the Operating System."
  type        = string
  default     = "Ephemeral"
}

variable "enable_windows_auto_scaling" {
  description = "Enable Windows node pool autoscaling"
  type        = bool
  default     = false
}

variable "max_default_windows_node_count" {
  description = "(Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "min_default_windows_node_count" {
  description = "(Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "max_default_pod_count" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 110
}

variable "max_default_windows_pod_count" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 10
}


variable "linux_node_pool_enabled" {
  description = "Enable linux node pool"
  type        = bool
  default     = false
}

variable "linux_pool_name" {
  description = "The name of the linux node Pool (A linux Node Pool cannot have a name longer than 6 characters.)"
  type        = string
  default     = "linuxpool"
}

variable "linux_vm_size" {
  description = "The size of the linux Virtual Machine, such as Standard_D2ds_v5"
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "linux_node_count" {
  description = "The number of Nodes that should exist in the Pool. Please set `node_count` `null` while `enable_auto_scaling` is `true` to avoid possible `node_count` changes."
  type        = number
  default     = null
}

variable "linux_os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 50
}


variable "linux_os_disk_type" {
  description = "The type of disk which should be used for the Operating linux."
  type        = string
  default     = "Ephemeral"
}

variable "enable_linux_auto_scaling" {
  description = "Enable linux node pool autoscaling"
  type        = bool
  default     = false
}

variable "max_default_linux_node_count" {
  description = "(Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "min_default_linux_node_count" {
  description = "(Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "max_default_linux_pod_count" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 110
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "Type type of identity used for the managed cluster. Possible values are 'SystemAssigned' and 'UserAssigned'. If 'UserAssigned' is set, a 'user_assigned_identity_id' must be set as well."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_id" {
  description = "(Optional) the ID of a user assigned identity"
  type        = list(string)
  default     = null
}

variable "kubelet_client_id" {
  description = "(Required) the Client ID of a user assigned identity for Kubelet"
  type        = string
  default     = null
}

variable "kubelet_object_id" {
  description = "(Required) the Object ID of a user assigned identity for Kubelet"
  type        = string
  default     = null
}

variable "kubelet_user_assigned_identity_id" {
  description = "(Required) the ID of a user assigned identity for Kubelet"
  type        = string
  default     = null
}

variable "outbound_type" {
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer."
  type        = string
  default     = "loadBalancer"
}

variable "local_account_disabled" {
  description = "(Optional) If set to true, the cluster will not be able to use the local resource access control feature."
  type        = bool
  default     = true
}

variable "run_command_enabled" {
  description = "(Optional) Whether to enable run command for the cluster or not."
  type        = bool
  default     = false
}

variable "oidc_issuer_enabled" {
  description = "(Required) Enable or Disable the OIDC issuer URL."
  type        = bool
  default     = true
}

variable "enable_azure_keyvault_secrets_provider" {
  description = "Is the Azure Keyvault Screts Provider enabled?."
  type        = bool
  default     = true
}

variable "enable_api_server_access_profile" {
  description = "Is the Api Server Access Profile enabled?."
  type        = bool
  default     = false
}

variable "secret_rotation_enabled" {
  description = "(Optional) Is secret rotation enabled."
  type        = bool
  default     = true
}

variable "secret_rotation_interval" {
  description = "(Optional) The interval to poll for secret rotation. Defaults to 2 minutes."
  type        = string
  default     = "2m"
}

variable "automatic_upgrade_channel" {
  description = "(Optional) the upgrade channel for this Kubernetes Cluster. Possible values are 'patch', 'rapid', 'node-image' and 'stable'. Defaults to 'stable'."
  type        = string
  default     = "stable"
}

variable "node_os_upgrade_channel" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster Nodes' OS Image. Possible values are Unmanaged, SecurityPatch, NodeImage and None. Defaults to NodeImage."
  type        = string
  default     = "NodeImage"
}

variable "windows_proximity_placement_group_id" {
  description = "(Optional) The ID of the proximity placement group to use for the Windows node pool."
  type        = string
  default     = null
}

variable "linux_proximity_placement_group_id" {
  description = "(Optional) The ID of the proximity placement group to use for the Linux node pool."
  type        = string
  default     = null
}

variable "pod_cidr" {
  description = "(Optional) The CIDR block to use for the Pod IPs. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. `docker_bridge_cidr`, `dns_service_ip` and `service_cidr` should all be empty or all should be set."
  type        = string
  default     = null
}

variable "dns_service_ip" {
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. `docker_bridge_cidr`, `dns_service_ip` and `service_cidr` should all be empty or all should be set."
  type        = string
  default     = null
}

variable "enable_blob_driver" {
  description = "(Optional) Is the Blob CSI driver enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "enable_disk_driver" {
  description = "(Optional) Is the Disk CSI driver enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "enable_file_driver" {
  description = "(Optional) Is the File CSI driver enabled? Defaults to true."
  type        = bool
  default     = true
}
