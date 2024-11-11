provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "devops-hw10" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/Network"
  vnet_name           = "${var.project_name}-network"
  subnet_name         = "${var.project_name}-Subnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops-hw10.name
  address_space       = ["10.0.0.0/16"]
  subnet_address_prefix = ["10.0.5.0/24"]
  nsg_name            = "${var.project_name}-NSG"
}

module "load_balancer_availability_set" {
  source                = "./modules/LB_and_AS"
  availability_set_name = "${var.project_name}-AvailabilitySet"
  load_balancer_name    = "${var.project_name}-LoadBalancer"
  location              = var.location
  resource_group_name   = azurerm_resource_group.devops-hw10.name
  subnet_id             = module.network.subnet_id
}

# Virtual Machine Module
locals {
  ssh_public_key = file(var.public_key_path)
}

module "virtual_machines" {
  source               = "./modules/Virtual_machines"
  vm_name_prefix       = "${var.project_name}-VM"
  vm_count             = 2
  location             = var.location
  resource_group_name  = azurerm_resource_group.devops-hw10.name
  availability_set_id  = module.load_balancer_availability_set.availability_set_id
  subnet_id            = module.network.subnet_id
  lb_backend_pool_id   = module.load_balancer_availability_set.backend_address_pool_id
  vm_size              = "Standard_B1s"
  admin_username       = "azureuser"
  ssh_public_key       = local.ssh_public_key
}