variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workload" {
  type        = string
  description = "The workload to deploy the Azure Service plan to."
}

variable "location_abbreviation" {
  type        = string
  description = "The abbreviation of the location/region where the Azure Service plan should be created."
  default     = "neu"
}


variable "environment" {
  description = "The environment to deploy the Azure Service plan to."
  type        = string
}

variable "location" {
  description = "The location/region where the Azure Service plan should be created."
  type        = string
}

variable "vnet_id" {
  description = "The ID of the Vnet"
  type        = string
}

variable "subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "subnet_delegated_id" {
  description = "The ID of the delegated subnet"
  type        = string
}
variable "tenant_id" {
  type        = string
  description = "The tenant id of the Azure principal."
  sensitive   = true
}

variable "cosmosdb_database_name" {

  type        = string
  description = "The name of the CosmosDB database."
}

variable "cosmosdb_endpoint" {
  type        = string
  description = "The endpoint of the CosmosDB database."
}

variable "cosmosdb_primary_key" {
  type        = string
  description = "The primary key of the CosmosDB database."
  sensitive   = true
}

variable "openai_location" {
  type        = string
  description = "The location of the OpenAI resource group."
}

variable "search_index" {
  type        = string
  description = "The name of the search index."
}
variable "client_id" {
  type        = string
  description = "The app id of the Azure principal."
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "The client secret of the Azure principal."
}

variable "subscription_id" {
  type        = string
  description = "The subscription id of the Azure principal."
  sensitive   = true
}

variable "openai_api_key" {
  type        = string
  description = "The API key of the OpenAI resource."
  sensitive   = true
}

# variable "managed_identity" {
#   type        = string
#   description = "The managed identity of the Azure principal."
#   sensitive   = true
# }

# variable "primary_connection_string" {
#   type        = string
#   description = "The primary connection string of the storage account."
#   sensitive   = true
# }

# variable "storage_account_name" {
#   type        = string
#   description = "The name of the storage account."
# }
# variable "storage_account_access_key" {
#   type        = string
#   description = "The access key of the storage account."
#   sensitive   = true
# }

variable "search_service_id" {
  type        = string
  description = "The ID of the search service."
}

variable "insights_connection_string" {
  type        = string
  description = "The connection string of the monitor."
  sensitive   = true
}
variable "subnet_logic_apps_id" {
  type        = string
  description = "The ID of the subnet for logic apps."
}

variable "acr_server_url" {
  type        = string
  description = "The server URL of the Azure Container Registry."
}

variable "acr_username" {
  type        = string
  description = "The username of the Azure Container Registry."
}

variable "acr_password" {
  type        = string
  description = "The password of the Azure Container Registry."
  sensitive   = true
}
# variable "storage_account_id" {
#   type        = string
#   description = "The ID of the storage account."
# }
# variable "backend_tag_name" {
#   type        = string
#   description = "The name of the tag."
# }
