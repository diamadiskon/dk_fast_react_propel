## This file is used to create the role assignments for the service principals of the Azure resources.
data "azurerm_client_config" "current" {
}

########################## Azure Function App Role Assignments ###############################
resource "azurerm_role_assignment" "sac-fa-app-chunk-skill-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.fa-app-chunk-skill-principal-id
}

resource "azurerm_role_assignment" "sbdc-fa-app-chunk-skill-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.fa-app-chunk-skill-principal-id
}

resource "azurerm_role_assignment" "sbdo-fa-app-chunk-skill-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.fa-app-chunk-skill-principal-id
}

resource "azurerm_role_assignment" "sac-fa-app-kpi-analytics-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.fa-app-kpi-analytics-principal-id
}

resource "azurerm_role_assignment" "sbdc-fa-app-kpi-analytics-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.fa-app-kpi-analytics-principal-id
}

resource "azurerm_role_assignment" "sbdo-fa-app-kpi-analytics-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.fa-app-kpi-analytics-principal-id
}

resource "azurerm_role_assignment" "sac-fa-snow-ingestion-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.fa-app-snow-ingestion-principal-id
}

resource "azurerm_role_assignment" "sqdc-fa-snow-ingestion-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.fa-app-snow-ingestion-principal-id
}

resource "azurerm_role_assignment" "sqdc-fa-app-kpi-analytics-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.fa-app-kpi-analytics-principal-id
}

resource "azurerm_role_assignment" "sqdc-fa-app-chunk-skill-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.fa-app-chunk-skill-principal-id
}

resource "azurerm_role_assignment" "sbdo-fa-snow-ingestion-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.fa-app-snow-ingestion-principal-id
}

######################### Azzure Search service principal ##############################
resource "azurerm_role_assignment" "search-service-role-assignment" {
  scope                = var.scope
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.search_service_principal_id
}
resource "azurerm_role_assignment" "sfd-search-service-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage File Data Privileged Reader"
  principal_id         = var.search_service_principal_id
}
resource "azurerm_role_assignment" "stdr-search-service-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Table Data Reader"
  principal_id         = var.search_service_principal_id
}
resource "azurerm_role_assignment" "sbdr-search-service-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.search_service_principal_id
}
resource "azurerm_role_assignment" "c-search-service-role-assignment" {
  scope                = var.scope
  role_definition_name = "Contributor"
  principal_id         = var.search_service_principal_id
}

################### Azure Web App Role Assignments #########################

resource "azurerm_role_assignment" "sac-app-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.app-brainbank-dev-principal-id
}
resource "azurerm_role_assignment" "sid-app-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Search Index Data Contributor"
  principal_id         = var.app-brainbank-dev-principal-id
}

resource "azurerm_role_assignment" "sbc-app-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.app-brainbank-dev-principal-id
}

resource "azurerm_role_assignment" "KeyVaultSecretsUser-app-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app-brainbank-dev-principal-id
}

resource "azurerm_role_assignment" "sac-app-brainbank-front-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.app-brainbank-front-dev-principal-id
}
resource "azurerm_role_assignment" "sid-app-brainbank-front-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Search Index Data Contributor"
  principal_id         = var.app-brainbank-front-dev-principal-id
}

resource "azurerm_role_assignment" "sbc-app-brainbank-front-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.app-brainbank-front-dev-principal-id
}

resource "azurerm_role_assignment" "KeyVaultSecretsUser-app-front-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app-brainbank-front-dev-principal-id
}

resource "azurerm_role_assignment" "sac-app-brainbank-src-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.app-brainbank-search-principal-id
}
resource "azurerm_role_assignment" "sid-app-brainbank-src-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Search Index Data Contributor"
  principal_id         = var.app-brainbank-search-principal-id
}

resource "azurerm_role_assignment" "sbc-app-brainbank-src-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.app-brainbank-search-principal-id
}

resource "azurerm_role_assignment" "KeyVaultSecretsUser-app-src-brainbank-dev-role-assignment" {
  scope                = var.scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app-brainbank-search-principal-id
}
##################### Form Recognizer Role Assignments #####################

resource "azurerm_role_assignment" "sbdc-form-recognizer-account-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.formrecognizer-principal-id
}

##################### Logic App Role Assignments ######################

resource "azurerm_role_assignment" "sac-logic-app-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-ca-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-ca-principal-id
}

resource "azurerm_role_assignment" "sac-logic-app-lsf-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-lsf-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-lfs-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-lsf-principal-id
}

resource "azurerm_role_assignment" "sac-logic-app-psf-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-psf-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-pfs-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-psf-principal-id
}

resource "azurerm_role_assignment" "sac-logic-app-sectrim-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-sectrim-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-sectrim-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-sectrim-principal-id
}

resource "azurerm_role_assignment" "sac-logic-app-snitaf-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-snitaf-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-snitaf-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-snitaf-principal-id
}

resource "azurerm_role_assignment" "sac-logic-app-spi-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.logic-app-spi-principal-id
}

resource "azurerm_role_assignment" "sbdo-logic-app-spi-role-assignment" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.logic-app-spi-principal-id
}

##################### Application gateway managed identity  ######################

resource "azurerm_user_assigned_identity" "appag_umid" {
  name                = "id-agw-001"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "appgw-keyvault-role-assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.appag_umid.principal_id
}

resource "azurerm_role_assignment" "appgw-role-assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.appag_umid.principal_id
  depends_on           = [azurerm_user_assigned_identity.appag_umid]
}


