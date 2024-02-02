resource "azurerm_resource_group" "main" {
    name = var.rg_name
    location = var.location
}

resource "azurerm_virtual_network" "main" {
    name                = var.vnet
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
    name                 = var.subnet
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.2.0/24"]
    depends_on = [ azurerm_virtual_network.main ]
}

resource "azurerm_network_interface" "main" {
    name                = "${var.vmname}-nic"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
}
}

resource "azurerm_virtual_machine" "main" {
    name                  = var.vmname
    location              = azurerm_resource_group.main.location
    resource_group_name   = azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    vm_size               = "Standard_DS1_v2"


    storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
}
    storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
}
    os_profile {
    computer_name  = var.vmname
    admin_username = "testadmin"
    admin_password = "Password1234!"
    
}
    os_profile_linux_config {
    disable_password_authentication = false
}
tags = {
    environment = "staging"
}
}
resource "azurerm_storage_account" "main" {
    name                     = "kjadfhadlf"
    resource_group_name      = azurerm_resource_group.main.name
    location                 = azurerm_resource_group.main.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "main" {
    name                  = "asdfgh"
    storage_account_name  = azurerm_storage_account.main.name
    container_access_type = "private"
}

