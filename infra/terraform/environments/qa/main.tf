locals {
  suffix = "${var.workload}-${var.environment}-${var.location_abbreviation}"
  # Owner_principals       = ["4c9e9244-id", "4fsfesef-7349-ID"]
  # Contributor_principals = ["ObjevctID-4338-86ed-0a3fdc899804", "4IDIDID-7349-DUMMYID-OBJECTf"]
  default_tags = {
    workload    = var.workload
    environment = var.environment
  }
}
#################### Data sources ####################
data "azurerm_subscription" "primary" {
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "snet_private" {
  name                 = var.subnet_private_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "snet_delegated" {
  name                 = var.subnet_delegated_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "subnet_logic_apps_name" {
  name                 = var.subnet_logic_apps_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

#################### Resources ####################

################### Ai Services ###################
module "ai" {
  source                = "../../modules/ai"
  location              = var.location
  openai_location       = var.openai_location
  environment           = var.environment
  workload              = var.workload
  location_abbreviation = var.location_abbreviation
  resource_group_name   = data.azurerm_resource_group.rg.name
  sku                   = "S0"
  vnet_id               = data.azurerm_virtual_network.vnet.id
  subnet_private_id     = data.azurerm_subnet.snet_private.id
  search_service_id     = module.search.search_service_id
  depends_on            = [module.search]
}

################### Search Service ###################

module "search" {
  source                = "../../modules/search"
  location              = var.location
  environment           = var.environment
  workload              = var.workload
  location_abbreviation = var.location_abbreviation
  resource_group_name   = data.azurerm_resource_group.rg.name
  sku                   = "standard2"
  subnet_private_id     = data.azurerm_subnet.snet_private.id
}

module "host" {
  source                 = "../../modules/host"
  location               = var.location
  environment            = var.environment
  workload               = var.workload
  location_abbreviation  = var.location_abbreviation
  resource_group_name    = data.azurerm_resource_group.rg.name
  vnet_id                = data.azurerm_virtual_network.vnet.id
  subnet_private_id      = data.azurerm_subnet.snet_private.id
  subnet_delegated_id    = data.azurerm_subnet.snet_delegated.id
  subnet_logic_apps_id   = data.azurerm_subnet.subnet_logic_apps_name.id
  tenant_id              = var.tenant_id
  cosmosdb_database_name = "cosmos-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  cosmosdb_endpoint      = "https://cosmosdb-${var.workload}-${var.environment}-${var.location_abbreviation}-001.documents.azure.com:443/"
  cosmosdb_primary_key   = var.cosmosdb_primary_key
  openai_location        = var.openai_location
  client_id              = var.client_id
  client_secret          = var.client_secret
  openai_api_key         = var.openai_api_key
  subscription_id        = var.subscription_id
  search_index           = "cch-index-pagenumber-test"
  # managed_identity           = var.managed_identity
  #storage_account_name       = module.storage.storage_account_name
  #primary_connection_string  = module.storage.storage_account_primary_connection_string
  #storage_account_access_key = module.storage.storage_account_access_key
  acr_server_url             = module.acr.acr-server-url
  acr_username               = module.acr.acr-username
  acr_password               = module.acr.acr-password
  insights_connection_string = module.monitor.connection_string
  #storage_account_id         = module.storage.storage_account_id
  # backend_tag_name           = var.backend_tag_name
  depends_on = [module.monitor, module.acr]
}


# module "storage" {
#   source                = "../../modules/storage"
#   location              = var.location
#   environment           = var.environment
#   workload              = var.workload
#   location_abbreviation = var.location_abbreviation
#   resource_group_name   = data.azurerm_resource_group.rg.name
#   subnet_private_id     = data.azurerm_subnet.snet_private.id
#   search_service_id     = module.search.search_service_id
#   subnet_logic_apps_id  = data.azurerm_subnet.subnet_logic_apps_name.id
#   depends_on            = [module.search]
# }

module "database" {
  source                = "../../modules/database"
  location              = var.location
  environment           = var.environment
  workload              = var.workload
  location_abbreviation = var.location_abbreviation
  resource_group_name   = data.azurerm_resource_group.rg.name
  subnet_private_id     = data.azurerm_subnet.snet_private.id

}

module "monitor" {
  source                = "../../modules/monitor"
  location              = var.location
  environment           = var.environment
  workload              = var.workload
  location_abbreviation = var.location_abbreviation
  resource_group_name   = data.azurerm_resource_group.rg.name
}

# module "role_assignment" {
#   source                               = "../../modules/security"
#   scope                                = data.azurerm_subscription.primary.id
#   environment                          = var.environment
#   workload                             = var.workload
#   location_abbreviation                = var.location_abbreviation
#   location                             = var.location
#   resource_group_name                  = data.azurerm_resource_group.rg.name
#   fa-app-chunk-skill-principal-id      = module.host.fa-app-chunk-skill-principal-id
#   fa-app-kpi-analytics-principal-id    = module.host.fa-app-kpi-analytics-principal-id
#   fa-app-snow-ingestion-principal-id   = module.host.fa-app-snow-ingestion-principal-id
#   search_service_principal_id          = module.search.search_service_principal_id
#   app-brainbank-dev-principal-id       = module.host.app-brainbank-dev-principal-id
#   app-brainbank-front-dev-principal-id = module.host.app-brainbank-front-dev-principal-id
#   app-brainbank-search-principal-id    = module.host.app-brainbank-search-principal-id
#   formrecognizer-principal-id          = module.ai.formrecognizer-principal-id
#   logic-app-ca-principal-id            = module.host.logic-app-ca-principal-id

#   logic-app-lsf-principal-id     = module.host.logic-app-lsf-principal-id
#   logic-app-psf-principal-id     = module.host.logic-app-psf-principal-id
#   logic-app-sectrim-principal-id = module.host.logic-app-sectrim-principal-id
#   logic-app-snitaf-principal-id  = module.host.logic-app-snitaf-principal-id
#   logic-app-spi-principal-id     = module.host.logic-app-spi-principal-id

#   depends_on = [module.host, module.search, module.ai]
# }

module "acr" {
  source                = "../../modules/acr"
  location              = var.location
  environment           = var.environment
  workload              = var.workload
  location_abbreviation = var.location_abbreviation
  resource_group_name   = data.azurerm_resource_group.rg.name
  subnet_private_id     = data.azurerm_subnet.snet_private.id

}

# module "storage_private" {

#   source                = "../../modules/storage_private"
#   location              = var.location
#   environment           = var.environment
#   workload              = var.workload
#   location_abbreviation = var.location_abbreviation
#   resource_group_name   = data.azurerm_resource_group.rg.name
#   subnet_private_id     = data.azurerm_subnet.snet_private.id
#   search_service_id     = module.search.search_service_id

#   depends_on = [module.storage, module.search, module.host, module.role_assignment]
# }