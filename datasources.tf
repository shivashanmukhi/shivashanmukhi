data "azurerm_resource_group" "rg" {
  name = "terragroup"
}

data "azurerm_virtual_network" "vnet" {
  name                = "terra-vnet"
  resource_group_name = "terragroup"
}

data "azurerm_subnet" "sbnet" {
  name                 = "arm_snet"
  virtual_network_name = "terra-vnet"
  resource_group_name  = "terragroup"
}

data "azurerm_key_vault" "keyvault" {
  name                = "terra-keyvault17"
  resource_group_name = "terragroup"
}

data "azurerm_key_vault_secret" "azurerm_key_vault_secret" {
  name         = "VMpswrd"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}