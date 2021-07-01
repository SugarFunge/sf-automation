resource "azurerm_resource_group" "sf-group" {
  name     = var.resource_group_name
  location = "East US 2"
}

resource "azurerm_virtual_network" "sf-vn-01" {
  name                = "${var.prefix}-vn-01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name
}

resource "azurerm_subnet" "sf-subnet-01" {
  name                 = "${var.prefix}-subnet-01"
  resource_group_name  = azurerm_resource_group.sf-group.name
  virtual_network_name = azurerm_virtual_network.sf-vn-01.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "sf-nsg-public-01" {
  name                = "${var.prefix}-nsg-public-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_security_group" "sf-nsg-private-01" {
  name                = "${var.prefix}-nsg-private-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_public_ip" "sf-nginx-ip-01" {
  name                = "${var.prefix}-nginx-ip-01"
  resource_group_name = azurerm_resource_group.sf-group.name
  location            = azurerm_resource_group.sf-group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sf-nic-nginx-01" {
  name                = "${var.prefix}-nic-public-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  ip_configuration {
    name                          = "sf-ipconfig-01"
    subnet_id                     = azurerm_subnet.sf-subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sf-nginx-ip-01.id
  }
}

resource "azurerm_network_interface_security_group_association" "sf-nic-nsg-nginx" {
  network_interface_id      = azurerm_network_interface.sf-nic-nginx-01.id
  network_security_group_id = azurerm_network_security_group.sf-nsg-public-01.id
}

resource "azurerm_public_ip" "sf-ipfs-ip-01" {
  name                = "${var.prefix}-ipfs-ip-01"
  resource_group_name = azurerm_resource_group.sf-group.name
  location            = azurerm_resource_group.sf-group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sf-nic-ipfs-01" {
  name                = "${var.prefix}-nic-ipfs-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  ip_configuration {
    name                          = "sf-ipconfig-01"
    subnet_id                     = azurerm_subnet.sf-subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sf-ipfs-ip-01.id
  }
}

resource "azurerm_network_interface_security_group_association" "sf-nic-nsg-ipfs" {
  network_interface_id      = azurerm_network_interface.sf-nic-ipfs-01.id
  network_security_group_id = azurerm_network_security_group.sf-nsg-private-01.id
}

resource "azurerm_public_ip" "sf-api-ip-01" {
  name                = "${var.prefix}-api-ip-01"
  resource_group_name = azurerm_resource_group.sf-group.name
  location            = azurerm_resource_group.sf-group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sf-nic-api-01" {
  name                = "${var.prefix}-nic-api-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  ip_configuration {
    name                          = "sf-ipconfig-01"
    subnet_id                     = azurerm_subnet.sf-subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sf-api-ip-01.id
  }
}

resource "azurerm_network_interface_security_group_association" "sf-nic-nsg-api" {
  network_interface_id      = azurerm_network_interface.sf-nic-api-01.id
  network_security_group_id = azurerm_network_security_group.sf-nsg-private-01.id
}

resource "azurerm_public_ip" "sf-node-ip-01" {
  name                = "${var.prefix}-node-ip-01"
  resource_group_name = azurerm_resource_group.sf-group.name
  location            = azurerm_resource_group.sf-group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sf-nic-node-01" {
  name                = "${var.prefix}-nic-node-01"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  ip_configuration {
    name                          = "sf-ipconfig-01"
    subnet_id                     = azurerm_subnet.sf-subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sf-node-ip-01.id
  }
}

resource "azurerm_network_interface_security_group_association" "sf-nic-nsg-node-01" {
  network_interface_id      = azurerm_network_interface.sf-nic-node-01.id
  network_security_group_id = azurerm_network_security_group.sf-nsg-private-01.id
}

resource "azurerm_public_ip" "sf-node-ip-02" {
  name                = "${var.prefix}-node-ip-02"
  resource_group_name = azurerm_resource_group.sf-group.name
  location            = azurerm_resource_group.sf-group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sf-nic-node-02" {
  name                = "${var.prefix}-nic-node-02"
  location            = azurerm_resource_group.sf-group.location
  resource_group_name = azurerm_resource_group.sf-group.name

  ip_configuration {
    name                          = "sf-ipconfig-01"
    subnet_id                     = azurerm_subnet.sf-subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sf-node-ip-02.id
  }
}

resource "azurerm_network_interface_security_group_association" "sf-nic-nsg-node-02" {
  network_interface_id      = azurerm_network_interface.sf-nic-node-02.id
  network_security_group_id = azurerm_network_security_group.sf-nsg-private-01.id
}
