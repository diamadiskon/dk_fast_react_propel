data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

###################### App Service Plan ######################
resource "azurerm_service_plan" "plan_linux" {
  name                = "plan-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B2"
}

resource "azurerm_service_plan" "plan_logic_apps" {
  name                = "plan-logicapps-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = "WS2"
}

############################ Storage Account ############################

resource "azurerm_storage_account" "storageaccount" {
  name                            = "st${var.workload}${var.environment}${var.location_abbreviation}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  # network_rules {
  #   default_action             = "Deny"
  #   ip_rules                   = ["${chomp(data.http.myip.response_body)}"]
  #   virtual_network_subnet_ids = [var.subnet_logic_apps_id]
  #   bypass                     = ["AzureServices"]
  # }
}

# resource "azurerm_storage_account_network_rules" "storage_rules_after_storage_account_creation" {
#   storage_account_id = azurerm_storage_account.storageaccount.id
#   default_action     = "Allow"
#   # ip_rules                   = ["${chomp(data.http.myip.response_body)}"]
#   # virtual_network_subnet_ids = [var.subnet_logic_apps_id]
#   # bypass                     = ["AzureServices"]
#   depends_on = [azurerm_storage_account.storageaccount]

# }



resource "azurerm_storage_share" "share" {
  name                 = "share${var.workload}${var.environment}${var.location_abbreviation}"
  storage_account_name = azurerm_storage_account.storageaccount.name
  quota                = 50
  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}

###################### App Service ######################

resource "azurerm_linux_web_app" "app-brainbank-chat-dev" {
  name                = "app-${var.workload}-chat-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan_linux.id

  # Configure Docker Image to load on start
  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site
    scm_use_main_ip_restriction       = true
    # Allow Azure Pipelines to access scm site for deployment
    ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }

  }
  public_network_access_enabled = true

  app_settings = {
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL              = var.acr_server_url
    DOCKER_REGISTRY_SERVER_USERNAME         = var.acr_username
    DOCKER_REGISTRY_SERVER_PASSWORD         = var.acr_password
    "ALLOWED_ORIGIN"                        = "http://localhost:4200",
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.insights_connection_string,
    "AZURE_AUTH_TENANT_ID"                  = var.tenant_id,
    "AZURE_COSMOSDB_DATABASE_NAME"          = var.cosmosdb_database_name,
    "AZURE_COSMOSDB_ENDPOINT"               = var.cosmosdb_endpoint,
    "AZURE_COSMOSDB_PRIMARY_KEY"            = var.cosmosdb_primary_key,
    "AZURE_ENV_NAME"                        = "coca-cola",
    "AZURE_FORMRECOGNIZER_RESOURCE_GROUP"   = var.resource_group_name,
    "AZURE_FORMRECOGNIZER_SERVICE"          = "formrecognizer-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "AZURE_LOCATION"                        = var.location,
    "AZURE_OPENAI_CHATGPT_DEPLOYMENT"       = "gpt-4-turbo",
    "AZURE_OPENAI_CHATGPT_MODEL"            = "gpt-4",
    "AZURE_OPENAI_CHATGPT_MODEL_VERSION"    = "2023-07-01-preview",
    "AZURE_OPENAI_EMB_DEPLOYMENT"           = "text-embedding-ada-002",
    "AZURE_OPENAI_EMB_MODEL_NAME"           = "text-embedding-ada-002",
    "AZURE_OPENAI_RESOURCE_GROUP"           = var.openai_location,
    "AZURE_OPENAI_SERVICE"                  = "openai-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "AZURE_RESOURCE_GROUP"                  = var.resource_group_name,
    "AZURE_SEARCH_INDEX"                    = var.search_index,
    "AZURE_SEARCH_QUERY_LANGUAGE"           = "en-us",
    "AZURE_SEARCH_QUERY_SPELLER"            = "lexicon",
    "AZURE_SEARCH_SERVICE"                  = "search-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "AZURE_SEARCH_SERVICE_RESOURCE_GROUP"   = var.resource_group_name,
    "AZURE_SERVER_APP_ID"                   = var.client_id,
    "AZURE_SERVER_APP_SECRET"               = var.client_secret,
    "AZURE_STORAGE_ACCOUNT"                 = azurerm_storage_account.storageaccount.name,
    "AZURE_STORAGE_CONTAINER"               = "cch-test",
    "AZURE_STORAGE_RESOURCE_GROUP"          = var.resource_group_name,
    "AZURE_SUBSCRIPTION_ID"                 = var.subscription_id,
    "AZURE_TENANT_ID"                       = var.tenant_id,
    "AZURE_USE_AUTHENTICATION"              = "true",
    "BACKEND_URI"                           = "app-${var.workload}-${var.environment}-${var.location_abbreviation}-001.azurewebsites.net",
    "COSMOSDB_CONTAINER_CHAT_HISTORY"       = "chat-history-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "ENABLE_ORYX_BUILD"                     = "True",
    "OPENAI_API_KEY"                        = var.openai_api_key,
    "OPENAI_HOST"                           = "azure"
    "OPENAI_ORGANIZATION"                   = "",
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "True"
  }

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount]

}

resource "azurerm_linux_web_app" "app-brainbank-front-dev" {
  name                = "app-${var.workload}-front-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan_linux.id

  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site
    scm_use_main_ip_restriction       = true
    # Allow Azure Pipelines to access scm site for deployment
    ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }

  }
  public_network_access_enabled = true
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.insights_connection_string,
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_web_app" "app-brainbank-search-dev" {
  name                = "app-${var.workload}-search-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan_linux.id
  app_settings = {
    "AZURE_COSMOSDB_DATABASE_NAME"       = var.cosmosdb_database_name,
    "AZURE_COSMOSDB_ENDPOINT"            = var.cosmosdb_endpoint,
    "AZURE_KEY_VAULT_ENDPOINT"           = "https://kv-${var.workload}-${var.environment}-${var.location_abbreviation}-001.vault.azure.net/",
    "AZURE_OPENAI_CHATGPT_MODEL_VERSION" = "2023-07-01-preview",
    "AZURE_OPENAI_CHATGPT_MODEL"         = "gpt-4",
    "AZURE_OPENAI_EMBENDING_MODEL"       = "text-embedding-ada-002",
    "AZURE_OPENAI_ENDPOINT"              = "https://openai-${var.workload}-ai-hub-${var.environment}-${var.location_abbreviation}-001.openai.azure.com/",
    "AZURE_SEARCH_API_VERSION"           = "2023-07-01-Preview",
    "AZURE_SEARCH_ENDPOINT"              = "https://src-${var.workload}-${var.environment}-${var.location_abbreviation}-001.search.windows.net/",
    "AZURE_SEARCH_INDEXES"               = var.search_index,
    "AZURE_STORAGE_ACCOUNT"              = azurerm_storage_account.storageaccount.name,
    "AZURE_STORAGE_CONTAINER"            = "cch-test",
    "COSMOSDB_CONTAINER_CHAT_HISTORY"    = "chat-history-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "COSMOSDB_CONTAINER_SEARCH_HISTORY"  = "search-${var.workload}-${var.environment}-${var.location_abbreviation}-001",
    "SCM_DO_BUILD_DURING_DEPLOYMENT"     = "True"
  }
  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site
    scm_use_main_ip_restriction       = true
    # Allow Azure Pipelines to access scm site for deployment
    ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }

  }
  public_network_access_enabled = true
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount]
}

### Function Apps ###

resource "azurerm_linux_function_app" "fa-app-chunk-skill" {
  name                 = "app-chunk-skill-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location             = var.location
  resource_group_name  = var.resource_group_name
  service_plan_id      = azurerm_service_plan.plan_linux.id
  storage_account_name = azurerm_storage_account.storageaccount.name
  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site

    # Allow Azure Pipelines to access scm site for deployment
    scm_ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }


  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.insights_connection_string,
    "AzureWebJobsFeatureFlags"              = "EnableWorkerIndexing"
    "AzureWebJobsStorage"                   = azurerm_storage_account.storageaccount.primary_connection_string,
    "FUNCTIONS_EXTENSION_VERSION"           = "~4"
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "MAX_CHUNK_LENGTH"                      = "2048"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "1"
    "SENTENCE_SEARCH_LIMIT"                 = "100"
    "XDG_CACHE_HOME"                        = "/tmp/.cache"
  }

  identity {
    type = "SystemAssigned"

  }

  depends_on = [azurerm_storage_account.storageaccount]
}

resource "azurerm_linux_function_app" "fa-app-kpi-analytics" {
  name                 = "app-kpi-analytics-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location             = var.location
  resource_group_name  = var.resource_group_name
  service_plan_id      = azurerm_service_plan.plan_linux.id
  storage_account_name = azurerm_storage_account.storageaccount.name
  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site

    # Allow Azure Pipelines to access scm site for deployment
    scm_ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }
  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.insights_connection_string,
    "AzureWebJobsFeatureFlags"              = "EnableWorkerIndexing"
    "AzureWebJobsStorage"                   = azurerm_storage_account.storageaccount.primary_connection_string,
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount]
}

resource "azurerm_linux_function_app" "fa-app-snow-ingestion" {
  name                 = "app-snow-ingestion-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location             = var.location
  resource_group_name  = var.resource_group_name
  service_plan_id      = azurerm_service_plan.plan_linux.id
  storage_account_name = azurerm_storage_account.storageaccount.name
  site_config {
    ip_restriction_default_action     = "Deny" # Deny all traffic by default
    scm_ip_restriction_default_action = "Deny" # Deny all traffic by default for scm site

    # Allow Azure Pipelines to access scm site for deployment
    scm_ip_restriction {
      name        = "Azure-Pipelines"
      action      = "Allow"
      service_tag = "AzureCloud"
      description = "Allow Azure Pipelines to access scm site for deployment"
    }
  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.insights_connection_string,
    "AzureWebJobsFeatureFlags"              = "EnableWorkerIndexing",
    "AzureWebJobsStorage"                   = azurerm_storage_account.storageaccount.primary_connection_string,

  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount]
}
### App Service Vnet Integration ###
resource "azurerm_app_service_virtual_network_swift_connection" "app_brainbank_dev_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app-brainbank-chat-dev.id
  subnet_id      = var.subnet_delegated_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_brainbank_front_dev_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app-brainbank-front-dev.id
  subnet_id      = var.subnet_delegated_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_brainbank_search_dev_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app-brainbank-search-dev.id
  subnet_id      = var.subnet_delegated_id
}


############################ Logic Apps ############################

resource "azurerm_logic_app_standard" "app-ca" {
  name                       = "app-ca-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  storage_account_share_name = azurerm_storage_share.share.name

  site_config {

    vnet_route_all_enabled = true
  }
  # app_settings = {

  #   "AzureWebJobsStorage" = var.primary_connection_string
  # }

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}


resource "azurerm_logic_app_standard" "app-lsf" {
  name                       = "app-lsf-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  site_config {
    always_on                     = false
    public_network_access_enabled = false
    vnet_route_all_enabled        = true
  }
  app_settings = {

    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}

resource "azurerm_logic_app_standard" "app-psf" {
  name                       = "app-psf-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key

  site_config {

    vnet_route_all_enabled = true
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}

resource "azurerm_logic_app_standard" "app-sectrim" {
  name                       = "app-sectrim-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key

  site_config {

    vnet_route_all_enabled = true
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}

resource "azurerm_logic_app_standard" "app-snitaf" {
  name                       = "app-snitaf-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key

  site_config {

    vnet_route_all_enabled = true
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}
resource "azurerm_logic_app_standard" "app-spi" {
  name                       = "app-spi-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan_logic_apps.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key

  site_config {

    vnet_route_all_enabled = true
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.storageaccount,
  azurerm_storage_share.share]
}

########################## Function App Vnet Integration ##########################

resource "azurerm_app_service_virtual_network_swift_connection" "app_chunk_skill_vnet_integration" {
  app_service_id = azurerm_linux_function_app.fa-app-chunk-skill.id
  subnet_id      = var.subnet_delegated_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_kpi_analytics_vnet_integration" {
  app_service_id = azurerm_linux_function_app.fa-app-kpi-analytics.id
  subnet_id      = var.subnet_delegated_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_snow_ingestion_vnet_integration" {
  app_service_id = azurerm_linux_function_app.fa-app-snow-ingestion.id
  subnet_id      = var.subnet_delegated_id
}

########################## Logic App Vnet Integration ##########################

resource "azurerm_app_service_virtual_network_swift_connection" "app_ca_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-ca.id
  subnet_id      = var.subnet_logic_apps_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_lsf_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-lsf.id
  subnet_id      = var.subnet_logic_apps_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_psf_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-psf.id
  subnet_id      = var.subnet_logic_apps_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_sectrim_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-sectrim.id
  subnet_id      = var.subnet_logic_apps_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_snitaf_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-snitaf.id
  subnet_id      = var.subnet_logic_apps_id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_spi_vnet_integration" {
  app_service_id = azurerm_logic_app_standard.app-spi.id
  subnet_id      = var.subnet_logic_apps_id
}

################### MUST BE COMMENTED OUT  IF YOU RUN IT TWICE ############################

resource "azurerm_search_shared_private_link_service" "srctostorageconnectionblob" {
  name               = "blob-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
  search_service_id  = var.search_service_id
  subresource_name   = "blob"
  target_resource_id = azurerm_storage_account.storageaccount.id
  request_message    = "Please Approve"

  depends_on = [
    azurerm_storage_account.storageaccount, azurerm_private_endpoint.blob_private_endpoint
  ]

}

resource "azurerm_search_shared_private_link_service" "srctostorageconnectiontable" {
  name               = "table-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
  search_service_id  = var.search_service_id
  subresource_name   = "table"
  target_resource_id = azurerm_storage_account.storageaccount.id
  request_message    = "Please Approve"
  depends_on = [
  azurerm_storage_account.storageaccount, azurerm_search_shared_private_link_service.srctostorageconnectionblob, azurerm_private_endpoint.table_private_endpoint]

}

resource "azurerm_search_shared_private_link_service" "srctostorageconnectionfile" {
  name               = "file-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
  search_service_id  = var.search_service_id
  subresource_name   = "file"
  target_resource_id = azurerm_storage_account.storageaccount.id
  request_message    = "Please Approve"
  depends_on = [
    azurerm_storage_account.storageaccount, azurerm_private_endpoint.file-private_endpoint
  ]

}

resource "azurerm_search_shared_private_link_service" "srctostorageconnectionqueue" {
  name               = "dfs-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
  search_service_id  = var.search_service_id
  subresource_name   = "dfs"
  target_resource_id = azurerm_storage_account.storageaccount.id
  request_message    = "Please Approve"

  depends_on = [
    azurerm_storage_account.storageaccount, azurerm_private_endpoint.queue_private_endpoint
  ]

}

# ########################## Storage Account Network Rules after logic app ##########################

resource "azurerm_storage_account_network_rules" "storage_rules" {
  storage_account_id         = azurerm_storage_account.storageaccount.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [var.subnet_logic_apps_id]
  depends_on = [
    azurerm_app_service_virtual_network_swift_connection.app_spi_vnet_integration,
    azurerm_app_service_virtual_network_swift_connection.app_snitaf_vnet_integration,
    azurerm_app_service_virtual_network_swift_connection.app_sectrim_vnet_integration,
    azurerm_app_service_virtual_network_swift_connection.app_psf_vnet_integration,
    azurerm_app_service_virtual_network_swift_connection.app_lsf_vnet_integration,
    azurerm_app_service_virtual_network_swift_connection.app_ca_vnet_integration,
    azurerm_search_shared_private_link_service.srctostorageconnectionblob,
    azurerm_search_shared_private_link_service.srctostorageconnectiontable,
    azurerm_search_shared_private_link_service.srctostorageconnectionfile,
    azurerm_search_shared_private_link_service.srctostorageconnectionqueue
  ]
}


############################ Private Endpoints ############################

resource "azurerm_private_endpoint" "pep-app" {
  name                = "pep-app-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-private-service-connection"
    private_connection_resource_id = azurerm_linux_web_app.app-brainbank-chat-dev.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

}


resource "azurerm_private_endpoint" "pep-app-front" {
  name                = "pep-app-front-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-front-private-service-connection"
    private_connection_resource_id = azurerm_linux_web_app.app-brainbank-front-dev.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "pep-app-search" {
  name                = "pep-app-search-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-search-private-service-connection"
    private_connection_resource_id = azurerm_linux_web_app.app-brainbank-search-dev.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "pep-fa-app-chunk-skill" {
  name                = "pep-fa-app-chunk-skill-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-chunk-skill-private-service-connection"
    private_connection_resource_id = azurerm_linux_function_app.fa-app-chunk-skill.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "pep-fa-app-kpi-analytics" {
  name                = "pep-fa-app-kpi-analytics-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "fa-app-kpi-analytics-private-service-connection"
    private_connection_resource_id = azurerm_linux_function_app.fa-app-kpi-analytics.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
resource "azurerm_private_endpoint" "pep-fa-app-snow-ingestion" {
  name                = "pep-fa-app-snow-ingestion-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "fa-app-snow-ingestion-private-service-connection"
    private_connection_resource_id = azurerm_linux_function_app.fa-app-snow-ingestion.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

################### Private Endpoints for Logic Apps ######################

resource "azurerm_private_endpoint" "pep-app-ca" {
  name                = "pep-app-ca-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-ca-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-ca.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "pep-app-lsf" {
  name                = "pep-app-lsf-brainbank-dev-001-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-lsf-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-lsf.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
resource "azurerm_private_endpoint" "pep-app-psf" {
  name                = "pep-app-psf-brainbank-dev-001-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-psf-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-psf.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
resource "azurerm_private_endpoint" "pep-app-sectrim" {
  name                = "pep-app-sectrim-brainbank-dev-001-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-sectrim-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-sectrim.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
resource "azurerm_private_endpoint" "pep-app-snitaf" {
  name                = "pep-app-snitaf-brainbank-dev-001-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-snitaf-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-snitaf.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
resource "azurerm_private_endpoint" "pep-app-spi" {
  name                = "pep-app-spi-brainbank-dev-001-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "app-spi-private-service-connection"
    private_connection_resource_id = azurerm_logic_app_standard.app-spi.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

################### Private Endpoints for Storage ######################

resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name                = "pep-blob-storageaccount-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id

  private_service_connection {
    name                           = "storage-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}

resource "azurerm_private_endpoint" "table_private_endpoint" {
  name                = "pep-table-storageaccount-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id

  private_service_connection {
    name                           = "storage-table-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}

resource "azurerm_private_endpoint" "file-private_endpoint" {
  name                = "pep-file-storageaccount-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id

  private_service_connection {
    name                           = "storage-file-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}

resource "azurerm_private_endpoint" "queue_private_endpoint" {
  name                = "pep-queue-storageaccount-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id


  private_service_connection {
    name                           = "storage-queue-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}


