# Not supposed to be in the repository, but provided here for reference.
resource_group_name = "rg-aks-staging"
location            = "eastus"
vnet_name           = "vnet-aks-staging"
address_space       = ["10.1.0.0/16"]
subnet_name         = "snet-aks"
subnet_prefixes     = ["10.1.1.0/24"]
aks_name            = "aks-staging"
dns_prefix          = "aksstaging"
node_count          = 2
min_count           = 2
max_count           = 5
vm_size             = "Standard_DS2_v2"
acr_name            = "aksstaging"
acr_rg_name         = "rg-ecr-staging"
tags = {
  environment = "staging"
  project     = "aks"
}

node_pool_configs = [
  {
    name = "nodepool1"
    tags = {
      environment = "staging"
      project     = "frontend"
      owner       = "team-a"
    }
    node_taints = ["app=frontend:NoSchedule"] # Example taint for frontend applications
  },
  {
    name = "nodepool2"
    tags = {
      environment = "staging"
      project     = "backend"
      owner       = "team-b"
    }
    node_taints = ["app=backend:NoExecute"] # Example taint for backend applications
  }
]