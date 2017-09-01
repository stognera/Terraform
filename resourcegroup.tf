#Declare our resource group to manage
resource "azurerm_resource_group" "Adam" {
  name     = "Adam"
  location = "East US"
}
