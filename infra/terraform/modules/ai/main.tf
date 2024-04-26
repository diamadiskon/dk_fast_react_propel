resource "azurerm_cognitive_account" "cognitive_service" {
  name                          = "ai-services-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku
  kind                          = "CognitiveServices" # for Multi-service Account
  public_network_access_enabled = true
  custom_subdomain_name         = "ai-services-${var.workload}-${var.environment}-${var.location_abbreviation}-003"

}
resource "azurerm_cognitive_account" "form_recognizer_account" {
  name                          = "formrecognizer-${var.workload}-${var.environment}-${var.location_abbreviation_ai}-001"
  location                      = var.formrecognizer_location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku
  kind                          = "FormRecognizer" # for FormRecognizer
  public_network_access_enabled = false
  custom_subdomain_name         = "formrecognizer-${var.workload}-${var.environment}-${var.location_abbreviation_ai}-003"
  identity {
    type = "SystemAssigned"

  }
}

resource "azurerm_cognitive_account" "openai_account" {
  name                          = "openai-${var.workload}-${var.environment}-${var.location_abbreviation_ai}-001"
  location                      = var.openai_location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku
  kind                          = "OpenAI" # for OpenAi
  public_network_access_enabled = false
  custom_subdomain_name         = "openai-${var.workload}-${var.environment}-${var.location_abbreviation_ai}-003"
}

## Private Endpoints

resource "azurerm_private_endpoint" "pep-ai-services" {
  name                = "pep-ai-services-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "ai-services-private-service-connection"
    private_connection_resource_id = azurerm_cognitive_account.cognitive_service.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

resource "azurerm_private_endpoint" "pep-formrecognizer" {
  name                = "pep-formrecognizer-${var.workload}-${var.environment}-${var.location_abbreviation_ai}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "formrecognizer-private-service-connection"
    private_connection_resource_id = azurerm_cognitive_account.form_recognizer_account.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

resource "azurerm_private_endpoint" "pep-openai" {
  name                = "pep-openai-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "openai-private-service-connection"
    private_connection_resource_id = azurerm_cognitive_account.openai_account.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

resource "azurerm_search_shared_private_link_service" "openai_account" {
  name               = "${var.workload}-${var.environment}-src-${var.location_abbreviation}"
  search_service_id  = var.search_service_id
  subresource_name   = "openai_account"
  target_resource_id = azurerm_cognitive_account.openai_account.id
  request_message    = "Please Approve"
}
