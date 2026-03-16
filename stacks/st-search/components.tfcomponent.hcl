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

component "app-recommendations" {
  source = "./comp-recommendations"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.this
  }
}

output "search-cache" {
  description = "Cache component for the search service of the online store"
  type = string
  value = component.app-cache.name
  sensitive = false
  ephemeral = false
}

output "search-rev-proxy" {
  description = "Reverse proxy component for the search service of the online store"
  type = string
  value = component.app-rev-proxy.name
  sensitive = false
  ephemeral = false
}

output "search-recommendations" {
  description = "Recommendations component for the search service of the online store"
  type = string
  value = component.app-recommendations.name
  sensitive = false
  ephemeral = false
}