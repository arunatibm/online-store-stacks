# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  type = string
}

required_providers {
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6.0"
  }
}

provider "random" "this" {}
provider "random" "random-app-cache" {}
provider "random" "random-app-rev-proxy" {}
provider "random" "random-app-payment" {}

component "app-cache" {
  source = "github.com/arunatibm/online-store-stacks.git//components/comp-cache"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.random-app-cache
  }
}

component "app-rev-proxy" {
  source = "github.com/arunatibm/online-store-stacks.git//components/comp-nginx"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.random-app-rev-proxy
  }
}

component "app-payment" {
  source = "./comp-payment"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.random-app-payment
  }
}

output "billing-cache" {
  description = "Cache component for the billing service of the online store"
  type = string
  value = component.app-cache.name
  sensitive = false
  ephemeral = false
}

output "billing-rev-proxy" {
  description = "Reverse proxy component for the billing service of the online store"
  type = string
  value = component.app-rev-proxy.name
  sensitive = false
  ephemeral = false
}

output "billing-payment" {
  description = "Payment component for the billing service of the online store"
  type = string
  value = component.app-payment.name
  sensitive = false
  ephemeral = false
}