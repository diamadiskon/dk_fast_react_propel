resource "azurerm_search_service" "search_service" {
  name                          = "src-${var.workload}-${var.environment}-${var.location_abbreviation}-01"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  local_authentication_enabled  = false
  public_network_access_enabled = false
  identity {
    type = "SystemAssigned"
  }
}

# Private Endpoint
resource "azurerm_private_endpoint" "pep-src-services" {
  name                = "pep-src-service-${var.workload}-${var.environment}-${var.location_abbreviation}-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "src-service-private-service-connection"
    private_connection_resource_id = azurerm_search_service.search_service.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }
}
