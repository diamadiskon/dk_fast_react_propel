resource "azurerm_application_insights" "app-all-insights-brainbank" {
  name                = "app-all-insights-${var.workload}-${var.environment}-${var.location_abbreviation}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
