terraform {
  source = "../../..//src/azure"
}

remote_state {
  backend = "azurerm"
  config  = {
    resource_group_name  = "sk8s"
    storage_account_name = "sk8sinfrastate"
    container_name       = "tfstate"
    key                  = "test.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  resource_group_name = "sk8s-cluster"
  network_name        = "sk8s-cluster-vnet"
  address_space       = "10.1.0.0/16"
  private_cluster     = false
  system_managed_dns  = false
  subnets             = [
    {
      name           = "cidr"
      address_prefix = "10.1.64.0/18"
      attributes     = {
        routing  = "internal"
        managed  = true
        services = [ "aks" ]
      }
    },
    {
      name           = "nodes"
      address_prefix = "10.1.0.0/18"
      attributes     = {
        routing  = "external"
        managed  = false
        services = [ "aks" ]
      }
    },
    {
      name           = "aci"
      address_prefix = "10.1.128.0/18"
      attributes     = {
        routing  = "external"
        managed  = false
        services = [ "aks" ] 
      }
    },
    {
      name           = "extras"
      address_prefix = "10.1.192.0/19"
      attributes     = {
        routing  = "internal"
        managed  = false
        services = [ "acr" ]
      }
    }
  ]
  tags = {
    project = "Sk8s"
    owner   = "GitHub Practice"
  }
}
