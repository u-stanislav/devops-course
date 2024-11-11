output "vm_ids" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}