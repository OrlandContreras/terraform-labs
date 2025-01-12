# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {

      source  = "hashicorp/azurerm"
      version = "=4.14.0"
    }
  }
  required_version = ">= 1.2.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.az_subscription_id
}

# Creating a resource group
resource "azurerm_resource_group" "rg" {
  name     = "az-function-rg"
  location = var.location
}

# Creating a storage account
resource "azurerm_storage_account" "az-sa" {
  name                     = "azfunctionappsac"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Creating service plan
resource "azurerm_service_plan" "az-sp" {
  name                = "az-windowsfunctionapp-sp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P1v2"
}

# Creating function app
resource "azurerm_windows_function_app" "az-function" {
  name                       = "az-windowsfunctionapp"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.az-sa.name
  storage_account_access_key = azurerm_storage_account.az-sa.primary_access_key
  service_plan_id            = azurerm_service_plan.az-sp.id

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
