provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devops-hw10" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/Network"
  vnet_name           = "${project_name}-network"
  subnet_name         = "${project_name}-Subnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops-hw10.id
  address_space       = ["10.0.0.0/16"]
  subnet_address_prefix = ["10.0.5.0/24"]
  nsg_name            = "${project_name}-NSG"
}

module "load_balancer_availability_set" {
  source                = "./modules/LB_and_AS"
  availability_set_name = "${project_name}-AvailabilitySet"
  load_balancer_name    = "${project_name}-LoadBalancer"
  location              = var.location
  resource_group_name   = azurerm_resource_group.devops-hw10.id
  subnet_id             = module.network.subnet_id
}

# Virtual Machine Module
locals {
  ssh_public_key  = [for path in var.public_key_path : file(path)]
}

module "virtual_machines" {
  source               = "./modules/Virtual_machines"
  vm_name_prefix       = "${project_name}-VM"
  vm_count             = 2
  location             = var.location
  resource_group_name  = azurerm_resource_group.devops-hw10.id
  availability_set_id  = module.load_balancer_availability_set.availability_set_id
  subnet_id            = module.network.subnet_id
  lb_backend_pool_id   = module.load_balancer_availability_set.backend_address_pool_id
  vm_size              = "Standard_B1s"
  admin_username       = "azureuser"
  ssh_public_key       = local.ssh_public_key
}