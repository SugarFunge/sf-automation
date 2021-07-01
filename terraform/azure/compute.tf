resource "azurerm_virtual_machine" "sf-nginx-01" {
  name                  = "${var.prefix}-nginx-01"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nic-nginx-01.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-nginx-01-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-nginx-01"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/ssh/id_rsa.pub")
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine" "sf-ipfs-01" {
  name                  = "${var.prefix}-ipfs-01"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nic-ipfs-01.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-ipfs-01-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-ipfs-01"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/ssh/id_rsa.pub")
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine" "sf-api-01" {
  name                  = "${var.prefix}-api-01"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nic-api-01.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-api-01-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-api-01"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/ssh/id_rsa.pub")
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine" "sf-node-01" {
  name                  = "${var.prefix}-node-01"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nic-node-01.id]
  vm_size               = "Standard_F8s_v2"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-node-01-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-node-01"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/ssh/id_rsa.pub")
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine" "sf-node-02" {
  name                  = "${var.prefix}-node-02"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nic-node-02.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-node-02-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-node-02"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/ssh/id_rsa.pub")
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}
