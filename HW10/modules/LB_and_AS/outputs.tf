output "availability_set_id" {
  value = azurerm_availability_set.hw10.id
}

output "load_balancer_id" {
  value = azurerm_lb.hw10.id
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.hw10.id
}