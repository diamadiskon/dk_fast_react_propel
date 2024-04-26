variable "my_cert_1_secret_id" {
  type        = string
  description = "The secret ID of the certificate in the Key Vault."
}
variable "workload" {
  type        = string
  description = "The workload to deploy the Application Gateway to."
}
variable "environment" {
  type        = string
  description = "The environment to deploy the Application Gateway to."
}
variable "location" {
  type        = string
  description = "The location of the Application Gateway."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}
variable "location_abbreviation" {
  type        = string
  description = "The location of the resource group."
}

variable "subnet_agw" {
  type        = string
  description = "The subnet ID of the Application Gateway."
}
variable "url" {
  type        = string
  description = "The URL of the front-end application."
}

variable "certificate_name" {
  type        = string
  description = "The name of the certificate in the Key Vault."
}
variable "appagumid" {
  type        = string
  description = "The user-assigned managed identity ID."
}
