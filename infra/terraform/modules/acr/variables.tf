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

variable "subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}
