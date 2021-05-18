variable "name" {
  description = "Name of Azure Kubernetes service."
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
}

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
  default     = "default"
}

variable "default_vm_size" {
  description = "The size of the Virtual Machine, such as Standard_D2_v4"
  type        = string
  default     = "Standard_B2ms"
}

variable "availability_zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Free"
}

variable "private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = false
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

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "kubenet"
}

variable "network_policy" {
  description = "Network policy to use for networking."
  type        = string
  default     = null
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
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

variable "os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
