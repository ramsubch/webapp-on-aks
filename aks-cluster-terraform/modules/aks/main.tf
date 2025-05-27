resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                 = "default"
    node_count           = var.node_count
    vm_size              = var.vm_size
    min_count            = var.min_count
    max_count            = var.max_count
    enable_auto_scaling  = true
    vnet_subnet_id       = var.subnet_id
    max_pods             = 110
    os_disk_size_gb      = 30
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

resource "azurerm_kubernetes_cluster_node_pool" "aks_additional_node_pools" {
  # The key for each instance in for_each will be the node pool name.
  # This ensures unique naming and allows for easy referencing.
  for_each = { for np in var.node_pool_configs : np.name => np }

  # Required properties for the node pool
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.value.name # Uses the 'name' from the current node pool config
  vm_size               = var.vm_size # Example VM size - keep consistent for same config
  node_count            = 1
  os_disk_size_gb       = 30
  vnet_subnet_id        = var.subnet_id # Use the same subnet as the default node pool


  enable_auto_scaling  = true
  min_count             = 1
  max_count             = 3

  # set node taints to prevent scheduling on these nodes
  node_taints = each.value.node_taints

  # Apply the tags from the current node pool config
  tags = each.value.tags
}