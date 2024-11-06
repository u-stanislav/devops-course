# create resource group
resource "azurerm_resource_group" "devops-hw9" {
  name     = var.resource_group_name
  location = var.location
}

# create virtual network
resource "azurerm_virtual_network" "devops-hw9" {
  name                = "devops-hw9-vnet"
  location            = azurerm_resource_group.devops-hw9.location
  resource_group_name = azurerm_resource_group.devops-hw9.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  count = 2
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.devops-hw9.name
  virtual_network_name = azurerm_virtual_network.devops-hw9.name
  address_prefixes     = ["10.0.${count.index + 1}.0/24"]
}


# create security group
resource "azurerm_network_security_group" "devops-hw9" {
  name                = "devops-hw9-nsg"
  location            = azurerm_resource_group.devops-hw9.location
  resource_group_name = azurerm_resource_group.devops-hw9.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  resource_group_name  = azurerm_resource_group.devops-hw9.name
  name                        = "allow_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_ips
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.devops-hw9.name
}

resource "azurerm_network_security_rule" "allow_http" {
  resource_group_name  = azurerm_resource_group.devops-hw9.name
  name                        = "allow_http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = var.allowed_ips
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.devops-hw9.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count = 2
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.devops-hw9.id
  depends_on = [ azurerm_network_security_group.devops-hw9, azurerm_subnet.subnet ]
}

# creating public ip
resource "azurerm_public_ip" "pip" {
  count               = 2
  name                = "terrafrom-${var.env_name}-pip-${count.index}"
  location            = azurerm_resource_group.devops-hw9.location
  resource_group_name = azurerm_resource_group.devops-hw9.name
  allocation_method   = "Static"
}

# create network interface
resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "terrafrom-${var.env_name}-nic-${count.index}"
  location            = azurerm_resource_group.devops-hw9.location
  resource_group_name = azurerm_resource_group.devops-hw9.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }

  depends_on = [ azurerm_public_ip.pip ]
}

locals {
  ssh_private_keys = [for path in var.private_key_paths : file(path)]
  ssh_public_keys  = [for path in var.public_key_paths : file(path)]
}

resource "azurerm_linux_virtual_machine" "vm" {
  count = 2
  name                = "devops-hw9-vm${count.index}"
  resource_group_name = azurerm_resource_group.devops-hw9.name
  location            = azurerm_resource_group.devops-hw9.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  
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
              echo "<h1>Hostname: $(hostname)</h1>" > /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF
            )
  tags = {
    environment = "testing"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = local.ssh_public_keys[count.index]
  }
}
