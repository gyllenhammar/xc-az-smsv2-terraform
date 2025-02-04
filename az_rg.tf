resource "azurerm_resource_group" "rg" {
  location = var.az_region
  name     = "${var.resource_prefix}-rg"
  tags = {
    "owner" = var.owner
  }
}
