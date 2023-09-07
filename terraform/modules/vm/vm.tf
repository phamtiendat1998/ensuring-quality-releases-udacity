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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoDIh4VUYja3M1zydQX3w/Grt7KR2jvnUrfJKldbKThDI6uHxXKQ3gWl0MrPcz8lVWo0cabWbpuLLgAs4EnTK/1ULZPlpK2pjnQ9xITbDM6vBXv9cwBHtQZoQdEhqTEtt6d4pi24wpmvLE2/e0a5GP90HWaeDvGvGPV44exYKgp51CnKnKxNy7DeIob4wi38Rz6noZB+/gF4GwaekwQkmuBKmik2e9t8lSqgnwDK1w03+hE+UkvEN4JlluuSYciSGB28P3K2t6AeiHGb0y7mfCUe3tvZ71i1Vn5FbNHi8QMdgOCCRuknroE7e/VaK8QtSMgG+27Rfa1W0Eb0ulWdrlfkW3EDzEq/msbALeusyOLBtC9UUMwKvHvrH+d0cKAR6SEjGthX9oHXg4WMcQ5RK5KiZk9ulP/4rtqDwMCdbfvRge2KvB/WGkBUljD1ksSbYpesW5Q99h1e1il3jIovFUnJ2Ln9K1Y+LA8UwZ9UPmRUu+jSG+kgwi0oelqxbz10M="
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
