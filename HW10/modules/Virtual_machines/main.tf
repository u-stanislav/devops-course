# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  count                = var.vm_count
  name                 = "${var.vm_name_prefix}${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  size                 = var.vm_size
  availability_set_id  = var.availability_set_id

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_username       = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Hostname: $(hostname)</h1> for devops course hw10" > /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF
            )
  depends_on = [ azurerm_network_interface.nic ]
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-nic${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    
  }

}

resource "azurerm_network_interface_backend_address_pool_association" "association" {
  count =  var.vm_count
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.lb_backend_pool_id
  depends_on = [ azurerm_network_interface.nic ]
}