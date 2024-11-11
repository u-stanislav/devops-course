# create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}


# create security group
resource "azurerm_network_security_group" "devops-hw10" {
  name                = "devops-hw10-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  resource_group_name  = var.resource_group_name
  name                        = "allow_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_ips
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.devops-hw10.name
}

resource "azurerm_network_security_rule" "allow_http" {
  resource_group_name  = var.resource_group_name
  name                        = "allow_http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = var.allowed_ips
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.devops-hw10.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.devops-hw10.id
  depends_on = [ azurerm_network_security_group.devops-hw10, azurerm_subnet.subnet ]
}

# creating public ip
resource "azurerm_public_ip" "pip" {
  name                = "terrafrom-${var.env_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# create network interface
resource "azurerm_network_interface" "nic" {
  name                = "terrafrom-${var.env_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  depends_on = [ azurerm_public_ip.pip ]
}