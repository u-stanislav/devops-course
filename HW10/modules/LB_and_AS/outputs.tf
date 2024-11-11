output "availability_set_id" {
  value = azurerm_availability_set.example.id
}

output "load_balancer_id" {
  value = azurerm_lb.example.id
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.example.id
}