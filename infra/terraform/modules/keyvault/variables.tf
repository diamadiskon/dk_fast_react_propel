variable "environment" {
  description = "The environment to deploy the Azure AI service to."
  type        = string
}

variable "location" {
  description = "The location/region where the Azure AI service should be created."
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

variable "tenant_id" {
  type        = string
  description = "ID of the tenant."
  sensitive   = true
}


variable "subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "subnet_agw_id" {
  description = "The ID of the subnet where the Application Gateway is deployed"
  type        = string
}

variable "object_id" {
  description = "The object ID of the managed identity"
  type        = string
}

variable "agw_object_id" {
  description = "The object ID of the Application Gateway"
  type        = string
}
