# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

variable "prefix" {
  type = string
}

resource "random_string" "name" {
    length = 5
    special = false
}

output "name" {
  value = "${var.prefix}-nginx-${random_string.name.id}"
}