variable "environment" {
  description = "The environment to deploy the Azure AI service to."
  type        = string
}
variable "sku" {
  description = "The Tier to use for this Azure AI service."
  type        = string
  default     = "Standard"
}
variable "location" {
  description = "The location/region where the Azure AI service should be created."
  type        = string
}

variable "openai_location" {
  description = "The location/region where the OpenAI service should be created."
  type        = string
}

variable "formrecognizer_location" {
  description = "The location/region where the FormRecognizer service should be created."
  type        = string
}

variable "location_abbreviation_ai" {
  description = "The abbreviation of the location/region where the Azure AI service should be created."
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workload" {
  type        = string
  description = "The workload to deploy the Azure AI service to."
}

variable "location_abbreviation" {
  type        = string
  description = "The abbreviation of the location/region where the Azure AI service should be created."
  default     = "neu"
}

variable "subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "vnet_id" {
  description = "The ID of the Vnet"
  type        = string
}

variable "search_service_id" {
  description = "The ID of the search service"
  type        = string
}
