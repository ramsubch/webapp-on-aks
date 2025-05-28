# Kubernetesd cluster and control plane node pool configuration
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    min_count           = var.min_count
    max_count           = var.max_count
    enable_auto_scaling = true
    vnet_subnet_id      = var.subnet_id
    max_pods            = 110
    os_disk_size_gb     = 30
    zones               = ["1", "2", "3"]
  }

  sku_tier = "Free" # Optional: Set to 'Free' tier for development/testing purposes

  # Can also be a user-assigned identity, if multipe identities are needed to be connected
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  # As automatic scaling is enabled, we ignore changes to the node count
  # This prevents Terraform from trying to set the node count back to the original value, when changes are made
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  tags = var.tags
}

# Additional node pools that act as worker nodes for the AKS cluster
resource "azurerm_kubernetes_cluster_node_pool" "aks_additional_node_pools" {
  # The key for each instance in for_each will be the node pool name.
  # This ensures unique naming and allows for easy referencing.
  for_each = { for np in var.node_pool_configs : np.name => np }

  # Required properties for the node pool
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.value.name # Uses the 'name' from the current node pool config
  # Reuse the same configuration as the default node pool, though this can be optimsed to customise each node pool further
  node_count          = var.node_count
  vm_size             = var.vm_size
  min_count           = var.min_count
  max_count           = var.max_count
  enable_auto_scaling = true
  vnet_subnet_id      = var.subnet_id
  max_pods            = 110
  os_disk_size_gb     = 30
  zones               = ["1", "2", "3"]

  # set node taints to prevent scheduling on these nodes
  node_taints = each.value.node_taints

  # Apply the tags from the current node pool config
  tags = each.value.tags
}


data "azurerm_container_registry" "acr_staging" {
  name                = var.acr_name
  resource_group_name = var.acr_rg_name
}

# Azure Container Registry (ACR) access configuration
resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = data.azurerm_container_registry.acr_staging.id # The scope of the role assignment, typically the ACR resource ID
  role_definition_name = "AcrPull"                                      # Allows pulling images from the registry
  # For the kubelet identity, which is used for pulling images.
  principal_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}