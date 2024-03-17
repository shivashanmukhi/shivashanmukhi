terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = var.clientid
  client_secret   = var.secret
  tenant_id       = var.tenantid
  subscription_id = var.Subscriptionid
}


terraform {
  backend "azurerm" {
    resource_group_name  = "terragroup"
    storage_account_name = "terrasto1624"
    container_name       = "tf-state"
    key                  = "prod.terraform.tf-state"
  }
}


# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }



resource "azurerm_storage_account" "storage" {
  name                     = lower(var.storageaccountname)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}
# resource "azurerm_virtual_network" "vnet" {
#   depends_on          = [azurerm_network_security_group.nsg]
#   name                = var.vnetname
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   address_space       = var.vnet_address
#   tags                = var.tags
# }
# resource "azurerm_subnet" "sbnet" {
#   depends_on           = [azurerm_virtual_network.vnet, azurerm_network_security_group.nsg]
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = var.sbnet_address
# }

resource "azurerm_public_ip" "terrapip" {
  name                = var.publicipname
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgname
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.tags
}

# resource "azurerm_subnet_network_security_group_association" "example" {
#   subnet_id                 = data.azurerm_subnet.sbnet.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }

resource "azurerm_network_interface" "nicname" {
  depends_on          = [azurerm_public_ip.terrapip, data.azurerm_virtual_network.vnet, data.azurerm_subnet.sbnet]
  name                = var.nicname
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.sbnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  depends_on          = [azurerm_network_interface.nicname]
  name                = var.vmname
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.adminname
  admin_password      = data.azurerm_key_vault_secret.azurerm_key_vault_secret.value
  network_interface_ids = [
    azurerm_network_interface.nicname.id,
  ]

  os_disk {
    name                 = "${var.vmname}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

output "storage_account_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "virtual_network_address" {
  value = data.azurerm_virtual_network.vnet.location
}