variable "workload" {
  type        = string
  description = "Name of the workload that will be deployed"
  validation {
    condition     = length(var.workload) >= 2 && length(var.workload) <= 10
    error_message = "Workload's length should be >= 2 and <= 10."
  }
}

variable "environment" {
  type        = string
  description = "Name of the workload's environment"
  validation {
    condition     = length(var.environment) >= 2 && length(var.environment) <= 10
    error_message = "Environment's length should be >= 2 and <= 10."
  }
}

variable "location" {
  type        = string
  description = "Azure region used for the deployment of all resources"
}

variable "openai_location" {
  type        = string
  description = "Azure region used for OpenAI cognitive service"
}

variable "location_abbreviation" {
  type        = string
  description = "Abbreviation of the location"
}

variable "client_id" {
  type        = string
  description = "Client id of the Azure principal."
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Client secret of the Azure principal."
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "ID of the tenant."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "ID of the subscription."
  sensitive   = true
}


## Existing Resources

## Existing resource group
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

## Existing virtual network
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network."

}

## Existing private subnet for endpoints
variable "subnet_private_name" {
  type        = string
  description = "Name of the subnet."
}

variable "subnet_delegated_name" {
  type        = string
  description = "Name of the subnet."
}

variable "openai_api_key" {
  type        = string
  description = "API key for OpenAI."
  default     = "value"
  sensitive   = true
}

variable "cosmosdb_primary_key" {
  type        = string
  description = "Primary key for CosmosDB."
  default     = "value"
  sensitive   = true
}
# variable "managed_identity" {
#   type        = string
#   description = "The managed identity of the Azure principal."
#   sensitive   = true
# }

variable "subnet_logic_apps_name" {
  type        = string
  description = "Name of the subnet."
}

# variable "backend_tag_name" {
#   type        = string
#   description = "Name of the tag."
# }
