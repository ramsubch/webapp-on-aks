# For now this STorage backned is pre-created in Azure.
# This can also be provisioned using Terraform, but for simplicity, we assume it exists.
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaksstaging"
    container_name       = "tfstate"
    key                  = "staging.terraform.tfstate"
  }
}