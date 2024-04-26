variable "location" {
  description = "The location/region where the Azure Search service should be created."
  type        = string
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workload" {
  type        = string
  description = "The workload to deploy the Azure Search service to."
}

variable "location_abbreviation" {
  type        = string
  description = "The abbreviation of the location/region where the Azure Search service should be created."
  default     = "neu"
}

variable "environment" {
  description = "The environment to deploy the Azure Search service to."
  type        = string
}

variable "sku" {
  description = "The Tier to use for this Azure Search service."
  type        = string
  default     = "standard2"
}

variable "subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}
