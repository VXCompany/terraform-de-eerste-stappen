terraform {
  required_providers {
    azurerm = {
        version = "=2.18.0"
    }
    archive = {
        version = "~> 1.3"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name = "terraform"
  location = "West Europe"
}
resource "azurerm_storage_account" "sa" {
  name = "${azurerm_resource_group.rg.name}funcsa"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "sc" {
  name = "function-releases"
  storage_account_name = azurerm_storage_account.sa.name
  container_access_type = "private"
}
data "archive_file" "init" {
  type = "zip"
  source_dir = "../function_app"
  output_path = "../function_app/functions${formatdate("DDMMYY", timestamp())}.zip"
}
resource "azurerm_storage_blob" "appcode" {
  name = "functionapp.zip"
  storage_account_name = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.sc.name
  type = "Block"
  source = data.archive_file.init.output_path
}
data "azurerm_storage_account_sas" "sasfunc" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only = true
  start = "2020-01-01"
  expiry = "2021-12-31"
  resource_types {
    object = true
    container = false
    service = false
  }
  services {
    blob = true
    queue = false
    table = false
    file = false
  }
  permissions {
    read = true
    write = false
    delete = false
    list = false
    add = false
    create = false
    update = false
    process = false
  }
}
resource "azurerm_app_service_plan" "appsp" {
  name = "${azurerm_resource_group.rg.name}funcappsp"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "FunctionApp"

  // Dynamic means Pay-per-Use
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
resource "azurerm_function_app" "fa" {
  name = "${azurerm_resource_group.rg.name}func"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appsp.id
  storage_account_name = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  version = "~3"
  https_only = true
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE = "readonly"
    HASH = base64encode(filesha256(data.archive_file.init.output_path))
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.sa.name}.blob.core.windows.net/${azurerm_storage_container.sc.name}/${azurerm_storage_blob.appcode.name}${data.azurerm_storage_account_sas.sasfunc.sas}"
  }
  identity {
    type = "SystemAssigned"
  }
}
