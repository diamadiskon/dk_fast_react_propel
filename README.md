# Health Monitoring Application

![Project Logo](project_logo.png)

## Table of Contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Features](#features)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Azure IaC for Infrastructure Provisioning](#azure-iac-for-infrastructure-provisioning)
- [Usage](#usage)
- [Data Storage](#data-storage)
- [Data Generation](#data-generation)
- [Authentication and Authorization](#authentication-and-authorization)
- [Docker Containerization](#docker-containerization)
- [Azure Pipelines](#azure-pipelines)
- [Testing and Quality Assurance](#testing-and-quality-assurance)
- [Documentation](#documentation)
- [Security and Compliance](#security-and-compliance)
- [Feedback and Continuous Improvement](#feedback-and-continuous-improvement)

## Introduction

This project is a health monitoring application that allows users to input and visualize their health data. The data is stored in a CosmosDB database and can be accessed securely. The application uses FastAPI for the backend and React for the frontend, providing a user-friendly interface for health data management.

![App Screenshot](app_screenshot.png)

## Project Overview

The project aims to:

- Enable users to input and monitor their health data.
- Provide data visualization through charts and graphs.
- Ensure secure data storage and access.
- Implement user authentication and authorization.
- Dockerize the application for easy deployment.
- Automate the build and deployment process using Azure Pipelines.

## Features

- User registration and login.
- Input and management of health data.
- Real-time data visualization with charts.
- User roles: regular users and household admins.
- Data security and compliance.
- Automated build, test, and deployment using Azure Pipelines.

## Technologies

- **Frontend**: React
- **Backend**: FastAPI
- **Database**: DynamoDB
- **Data Generation**: Faker library
- **Authentication and Authorization**: Propel Auth
- **Containerization**: Docker
- **Continuous Integration and Deployment**: Azure Pipelines

## Getting Started

### Prerequisites

- Azure CosmosDB
- Azure DevOps account for Azure Pipelines.
- Docker for containerization.
- Node.js for React frontend.
- Python for FastAPI backend.

### Installation locally

1. Clone the repository:

   ```sh
   git clone https://github.com/diamadiskon/dk_fast_react_propel.git

2. cd dk_fast_react_propel

3. Open localhost:3000 in your browser.

### Azure IaC for Infrastructure Provisioning

## Azure IaC for Infrastructure Provisioning

```sh
# Log in to Azure
az login

# Set the subscription
az account set --subscription <subscription_id>

# What-If deployment
az deployment sub what-if --subscription <subscription_id> --template-file bicep/azure.deploy.bicep --location [location] --parameters bicep/azure.deploy.parameters.json

# Validate deployment
az deployment sub validate --subscription <subscription_id> --template-file bicep/azure.deploy.bicep --location [location] --parameters bicep/azure.deploy.parameters.json

# Create deployment
az deployment sub create --subscription <subscription_id> --template-file bicep/azure.deploy.bicep --location [location] --parameters bicep/azure.deploy.parameters.json


