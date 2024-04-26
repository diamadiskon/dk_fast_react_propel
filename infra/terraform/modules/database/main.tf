resource "azurerm_cosmosdb_account" "db" {
  name                          = "cosmosdb-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  enable_automatic_failover     = false
  public_network_access_enabled = false
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  geo_location {
    location          = "northeurope"
    failover_priority = 0
  }
}

// Private Endpoint

resource "azurerm_private_endpoint" "pep-cosmosdb" {
  name                = "pep-cosmosdb-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "cosmosdb-private-service-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    is_manual_connection           = false
    subresource_names              = ["sql"]
  }
}
