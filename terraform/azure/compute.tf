resource "azurerm_virtual_machine" "sf-vms" {
  for_each              = var.resources
  name                  = "${var.prefix}-${each.value.name}-0${each.value.version}"
  location              = azurerm_resource_group.sf-group.location
  resource_group_name   = azurerm_resource_group.sf-group.name
  network_interface_ids = [azurerm_network_interface.sf-nics[each.key].id]
  vm_size               = each.value.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-${each.value.name}-0${each.value.version}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-${each.value.name}-0${each.value.version}"
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
