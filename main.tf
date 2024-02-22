# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "<SUB_ID>"
}

resource "azurerm_resource_group" "testRG" {
  name     = "test-RG"
  location = "northeurope"
}

resource "azurerm_virtual_network" "vtnet_test" {
  name                = "vtnet-test"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.testRG.location
  resource_group_name = azurerm_resource_group.testRG.name
}

resource "azurerm_subnet" "build_agent_subnet" {
  name                 = "build-agent"
  resource_group_name  = azurerm_resource_group.testRG.name
  virtual_network_name = azurerm_virtual_network.vtnet_test.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_public_ip" "public-ip-vm-build" {
  name                = "public-ip-vm-build"
  location            = azurerm_resource_group.testRG.location
  resource_group_name = azurerm_resource_group.testRG.name
  sku                 = "Basic"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic-vm-agent" {
  name                = "nic-vm-agent"
  location            = azurerm_resource_group.testRG.location
  resource_group_name = azurerm_resource_group.testRG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.build_agent_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip-vm-build.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-build" {
  name                = "build-vm"
  location            = azurerm_resource_group.testRG.location
  resource_group_name = azurerm_resource_group.testRG.name
  disable_password_authentication = false
  size                = "Standard_B1ls"
  admin_username      = "hugo"
  admin_password      = "Skh^r2$6>L3O"
  network_interface_ids = [
    azurerm_network_interface.nic-vm-agent.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "30"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12" # Ajustez cette valeur en fonction de la disponibilité
    sku       = "12"        # Ajustez en fonction de vos besoins et de la disponibilité
    version   = "latest"
  }
}