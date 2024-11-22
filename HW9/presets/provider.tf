provider "azurerm" {
  features {}
  subscription_id = "00963533-2602-4db1-9d9e-748b36f03a13"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "hw9-state"
    storage_account_name = "ustashw9storacc"
    container_name       = "tfstatepre"
    key                  = "terraform.tfstate"
  }
}