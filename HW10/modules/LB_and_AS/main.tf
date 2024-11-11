# Availability Set
resource "azurerm_availability_set" "hw10" {
  name                = var.availability_set_name
  location            = var.location
  resource_group_name = var.resource_group_name

  managed             = true
  platform_fault_domain_count = 2
  platform_update_domain_count = 5
}

# Load Balancer
resource "azurerm_lb" "hw10" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = var.public_ip
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "hw10" {
  loadbalancer_id = azurerm_lb.hw10.id
  name            = "BackendPool"
}

# Health Probe
resource "azurerm_lb_probe" "hw10" {
  loadbalancer_id = azurerm_lb.hw10.id
  name            = "HealthProbe"
  protocol        = "Tcp"
  port            = 80
  interval_in_seconds = 5
  number_of_probes   = 2
}

# Load Balancer Rule
# resource "azurerm_lb_rule" "hw10" {
#   loadbalancer_id            = azurerm_lb.hw10.id
#   name                       = "HTTP"
#   protocol                   = "Tcp"
#   frontend_port              = 80
#   backend_port               = 80
#   frontend_ip_configuration_name = azurerm_lb.hw10.frontend_ip_configuration[0].name
#   probe_id                   = azurerm_lb_probe.hw10.id
# }

# Load Balancer Rule (using backend_address_pool_ids)
resource "azurerm_lb_rule" "example_lb_rule" {
  loadbalancer_id                = azurerm_lb.hw10.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.hw10.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.hw10.id]
  probe_id                       = azurerm_lb_probe.hw10.id
}
