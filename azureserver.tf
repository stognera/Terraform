#import existing networks
resource "azurerm_subnet" "dmz" {
  address_prefix = "${var.address_prefix}"
  name = "${var.subnet_dmz_name}"
  resource_group_name = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
}
resource "azurerm_subnet" "inside" {
  address_prefix = "${var.address_prefix_inside}"
  name = "${var.subnet_inside_name}"
  resource_group_name = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
}

# create network interfaces
resource "azurerm_network_interface" "web01nic" {
    name = "web01nic"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.Adam.name}"

    ip_configuration {
        name = "adamweb01ipconf"
        subnet_id = "${azurerm_subnet.dmz.id}"
        private_ip_address_allocation = "static"
        private_ip_address = "${var.web01_ip_address}"
    }
}
resource "azurerm_network_interface" "web02nic" {
    name = "web02nic"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.Adam.name}"

    ip_configuration {
        name = "adamweb02ipconf"
        subnet_id = "${azurerm_subnet.dmz.id}"
        private_ip_address_allocation = "static"
        private_ip_address = "${var.web02_ip_address}"
    }
}
resource "azurerm_network_interface" "oracle01nic" {
    name = "oracle01nic"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.Adam.name}"

    ip_configuration {
        name = "oracle01ipconf"
        subnet_id = "${azurerm_subnet.inside.id}"
        private_ip_address_allocation = "static"
        private_ip_address = "${var.oracle01_ip_address}"
    }
}

#create VM
resource "azurerm_virtual_machine" "web01" {
  name                  = "web01"
  location              = "East US"
  resource_group_name   = "Adam"
  network_interface_ids = ["${azurerm_network_interface.web01nic.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web01osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "web01datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1"
  }

  os_profile {
    computer_name  = "web01adam"
    admin_username = "${var.localadmin}"
    admin_password = "${var.localadminpw}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "dev"
  }
}
resource "azurerm_virtual_machine" "web02" {
  name                  = "web02"
  location              = "East US"
  resource_group_name   = "Adam"
  network_interface_ids = ["${azurerm_network_interface.web02nic.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web02osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "web02datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1"
  }

  os_profile {
    computer_name  = "web02adam"
    admin_username = "${var.localadmin}"
    admin_password = "${var.localadminpw}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "dev"
  }
}
resource "azurerm_virtual_machine" "oracle01" {
  name                  = "oracle01"
  location              = "East US"
  resource_group_name   = "Adam"
  network_interface_ids = ["${azurerm_network_interface.oracle01nic.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "oracle01osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "oracle01datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1"
  }

  os_profile {
    computer_name  = "oracle01adam"
    admin_username = "${var.localadmin}"
    admin_password = "${var.localadminpw}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "dev"
  }
}
