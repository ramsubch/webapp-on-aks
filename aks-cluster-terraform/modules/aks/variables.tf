variable "aks_name" {
  description = "AKS cluster name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
}

variable "node_count" {
  description = "Initial node count"
  type        = number
  default     = 2
}

variable "min_count" {
  description = "Minimum node count for autoscaling"
  type        = number
  default     = 2
}

variable "max_count" {
  description = "Maximum node count for autoscaling"
  type        = number
  default     = 5
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# Define your node pool configurations here
# Each object in the list represents a new node pool
# 'name' is the node pool name (must be unique within the cluster)
# 'tags' is a map of key-value pairs for the tags
variable "node_pool_configs" {
  description = "A list of objects, each defining a node pool with its name and tags. Example: [{ name = \"nodepool1\", tags = { environment = \"dev\" } }]"
  type = list(object({
    name = string
    tags = map(string)
    node_taints = optional(list(string), []) # Added node_taints as an optional attribute
  }))
}