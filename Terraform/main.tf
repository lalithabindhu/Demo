

#RG01
resource "azurerm_resource_group" "rg01" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags = {
    "Environment"   = "Test"
    "Deployed from" = "Azure DevOps"

  }
}
#VNET01
resource "azurerm_virtual_network" "vnet01" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = var.vnet_address_space
  tags = {
    "Environment"   = "Test"
    "Deployed from" = "Azure DevOps"
  }
}
#SUBNET01
resource "azurerm_subnet" "subnet01" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes       = var.address_prefex
}
#Network_Interface_Card_linux
resource "azurerm_network_interface" "nicvm01lin" {
  name                = "${var.prefix}-nic-lin"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "testconfiguration_lin"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
  }
}
#Network_Interface_Card_windows
resource "azurerm_network_interface" "nicvm02win" {
  name                = "${var.prefix}-nic-win"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "testconfiguration_win"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
  }
}
#VM01
resource "azurerm_linux_virtual_machine" "vm01" {
  name                            = var.linux_vm_name
  resource_group_name             = azurerm_resource_group.rg01.name
  location                        = azurerm_resource_group.rg01.location
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nicvm01lin.id]
  tags = {
    "Environment"   = "Test"
    "Deployed from" = "Azure DevOps"

  }
  size           = "Standard_D4s_v3"
  admin_username = var.adminuser
  admin_password = var.adminpwd
  zone           = "1"


  os_disk {
    name                 = "lin-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "64"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
#vm02
resource "azurerm_windows_virtual_machine" "vm02" {
  name                  = var.Windows_vm_name
  resource_group_name   = azurerm_resource_group.rg01.name
  location              = azurerm_resource_group.rg01.location
  network_interface_ids = [azurerm_network_interface.nicvm02win.id]
  tags = {
    "Environment"   = "Test"
    "Deployed from" = "Azure DevOps"

  }
  size           = "Standard_D4s_v3"
  admin_username = var.adminuser
  admin_password = var.adminpwd
  zone           = "1"


  os_disk {
    name                 = "win-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "128"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
