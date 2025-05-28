variable "resource_group_name" {
  description = "Name of the resource group for AKS"
  type        = string
  default     = "rg-aks-staging"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-aks-staging"
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "subnet_name" {
  description = "Name of the subnet for AKS"
  type        = string
  default     = "snet-aks"
}

variable "subnet_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.240.0.0/16"]
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-staging"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aksstaging"
}

variable "node_count" {
  description = "Initial number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "min_count" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "max_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 5
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "staging"
    project     = "aks"
  }
}

variable "acr_name" {
  description = "The acr name from where images can be pulled"
  type        = string
}

variable "acr_rg_name" {
  description = "The Resource group where acr is located"
  type        = string
}

variable "node_pool_configs" {
  description = "A list of objects, each defining a node pool with its name and tags. Example: [{ name = \"nodepool1\", tags = { environment = \"dev\" } }]"
  type = list(object({
    name        = string
    tags        = map(string)
    node_taints = optional(list(string), []) # Added node_taints as an optional attribute
  }))
}