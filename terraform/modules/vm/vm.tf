resource "azurerm_network_interface" "main" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.pip_id}"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.application_type}-${var.resource_type}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  size                  = "Standard_DS2_v2"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.main.id]
  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbXigTMel8ch+zC4Dfsui/+Ce6scsGe7s5rZ+sjEoHGJMzPgmG7v0BjXsuUg2+yJzsFSZhsJ1z8WMIYmbygTc90i8hZBkix08yfdswKj+pala62PpSWtZUUv7J/3WfIOPjI5POIpH5deFNp5z2UHCWMsMoPOAkzKLT7Mjv6NmOHs1HbI1W96e3orXK8cofA/hHw0uwjWse5GC+Kv+E/ttSJ2znILXdVtqdRWPCMdPWGW3d82+wFnGwEYITO5bJCOsVYo062yIgMyFkZHtYKT3K8tpaGispGKgSrg2tdxEul7RyrNq17gkrGV/ofn62eqMNoCcPbQX7p05JIM6sVEbxlQuBigyHFXyTox09bik7IlFFkn380iqgq10mf5hYfHmFnYVCxc2pi7FNMK8cNeH8/XvTT5FqjAOh0qyn6maFblL9tTJAvHn3FlTxeym0523Mlt13qAarBZpVnFDVxgUiNWMsJn6e8mhp6mYdWtXpGW4tC73cKDypqEAeTaljIzs="
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
