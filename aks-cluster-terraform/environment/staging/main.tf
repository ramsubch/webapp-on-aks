module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source              = "../../modules/networking"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_name         = var.subnet_name
  subnet_prefixes     = var.subnet_prefixes
  tags                = var.tags
}

module "aks" {
  source              = "../../modules/aks"
  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  min_count           = var.min_count
  max_count           = var.max_count
  vm_size             = var.vm_size
  subnet_id           = module.networking.subnet_id
  tags                = var.tags
  acr_name            = var.acr_name
  acr_rg_name         = var.acr_rg_name
  node_pool_configs   = var.node_pool_configs
}