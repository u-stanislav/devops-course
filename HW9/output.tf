output "public_ip_addresses" {
  description = "Public IP addresses of the virtual machines"
  value       = [for ip in azurerm_public_ip.pip : ip.ip_address]
}

locals {
  description = "Public IP addresses of the virtual machines for jenkins"
    ips = templatefile("${path.module}/template.tpl", {
        dd_ip = [for ip in azurerm_public_ip.pip : ip.ip_address] 
    })
}

output "neededForAnsible" {
  value = local.ips
}