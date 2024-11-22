provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "hw9-state"
    storage_account_name = "ustashw9storacc"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}