resource "azurerm_container_registry" "acr" {
  name                          = "acr${var.workload}${var.environment}${var.location_abbreviation}01"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "pep-acr" {
  name                = "pep-acr-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "acr-private-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}
