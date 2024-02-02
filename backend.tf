terraform {
    backend "azurerm" {
    resource_group_name  = "testingrg"
    storage_account_name = "kjadfhadlf"
    container_name       = "asdfgh"
    key                  = "prod.terraform.tfstate"
}
}
