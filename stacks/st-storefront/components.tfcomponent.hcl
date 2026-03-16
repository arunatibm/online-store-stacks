# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  type = string
}

required_providers {
  random = {
    source  = "hashicorp/random"
    version = "~> 3.5.1"
  }
}

provider "random" "this" {}

component "app-cache" {
  source = "github.com/arunatibm/online-store-stacks.git//components/comp-cache"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.this
  }
}

component "app-rev-proxy" {
  source = "github.com/arunatibm/online-store-stacks.git//components/comp-nginx"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.this
  }
}

component "app-offers" {
  source = "./components/comp-offers"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.this
  }
}

output "storefront-cache" {
  description = "Cache component for the storefront service of the online store"
  type = string
  value = component.app-cache.name
  sensitive = false
  ephemeral = false
}

output "storefront-rev-proxy" {
  description = "Reverse proxy component for the storefront service of the online store"
  type = string
  value = component.app-rev-proxy.name
  sensitive = false
  ephemeral = false
}

output "storefront-offers" {
  description = "Offers component for the storefront service of the online store"
  type = string
  value = component.app-offers.name
  sensitive = false
  ephemeral = false
}