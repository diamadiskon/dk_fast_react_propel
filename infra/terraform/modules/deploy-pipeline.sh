#!/bin/bash

# Change directory to terraform development environment
cd ./environments/development || exit

# Terraform format
terraform fmt

# Terraform init
terraform init

# Terraform validate
terraform validate

# Terraform apply
terraform apply development.tfplan && rm development.tfplan
