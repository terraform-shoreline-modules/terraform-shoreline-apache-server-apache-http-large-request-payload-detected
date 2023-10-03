terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "large_request_payloads_in_apache_http" {
  source    = "./modules/large_request_payloads_in_apache_http"

  providers = {
    shoreline = shoreline
  }
}