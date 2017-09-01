resource "azurerm_public_ip" "WebTierLBIP" {
  name                          = "PrivateIPForLB"
  location                      = "East US"
  resource_group_name           = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
}
resource "azurerm_lb" "WebTierLB" {
  name                = "WebTierLoadBalancer"
  location            = "East US"
  resource_group_name = "${var.resource_group_name}"
  frontend_ip_configuration {
    name                          = "WebTierIP"
    subnet_id                     = "${azurerm_subnet.dmz.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.WebTierLB_ip_address}"
  }
}
resource "azurerm_lb_rule" "WebRule" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.WebTierLB.id}"
  name                           = "WebLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "WebTierIP"
}
resource "azurerm_lb_probe" "WebCheck" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.WebTierLB.id}"
  name                = "Port80response"
  port                = 80
}
resource "azurerm_lb_backend_address_pool" "WebServers" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.WebTierLB.id}"
  name                = "BackEndWebServers"
}
