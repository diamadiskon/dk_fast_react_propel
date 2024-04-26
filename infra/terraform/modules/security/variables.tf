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


variable "role_definition_id" {
  type        = string
  description = "The ID of the role definition to assign to the principal."
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "scope" {
  type        = string
  description = "The scope at which the role assignment or definition applies to, e.g. /subscriptions/00000000-0000-0000-0000-000000000000."
}

variable "principal_id" {
  type        = string
  description = "The ID of the principal to assign the role definition to."
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "fa-app-chunk-skill-principal-id" {
  type        = string
  description = "The principal ID of the Azure Function App."
}

variable "fa-app-kpi-analytics-principal-id" {
  type        = string
  description = "The principal ID of the Azure Function App."
}

variable "fa-app-snow-ingestion-principal-id" {
  type        = string
  description = "The principal ID of the Azure Function App."
}
variable "search_service_principal_id" {
  type        = string
  description = "The principal ID of the Azure Search service."
}
variable "app-brainbank-dev-principal-id" {
  type        = string
  description = "The principal ID of the Azure Web App."
}
variable "app-brainbank-front-dev-principal-id" {
  type        = string
  description = "The principal ID of the Azure Web App."
}
variable "app-brainbank-search-principal-id" {
  type        = string
  description = "The principal ID of the Azure Web App."
}


variable "formrecognizer-principal-id" {
  type        = string
  description = "The principal ID of the Azure Function App."
}

#################### Logic Apps Variables ####################
variable "logic-app-ca-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "logic-app-lsf-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "logic-app-psf-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "logic-app-sectrim-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "logic-app-snitaf-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "logic-app-spi-principal-id" {
  type        = string
  description = "The principal ID of the Logic App."
}

variable "keyvault_id" {
  type        = string
  description = "The ID of the Key Vault."
}
