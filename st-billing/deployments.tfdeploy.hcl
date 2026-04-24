# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
deployment_group "north_america" {
  auto_approve_checks = [ deployment_auto_approve.no_removals ]
}

deployment_group "europe" {
  auto_approve_checks = [ deployment_auto_approve.successful_plans ]
}

deployment_auto_approve "no_removals" {
  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plan has ${context.plan.changes.remove} resources to be removed."
  }
}

deployment_auto_approve "successful_plans" {
  check {
    condition = context.success == true
    reason = "Plans failed to complete."
  }
}

deployment "ca-west" {
  deployment_group = "north_america"
  inputs = {
    prefix    = "ca-west"
  }
}

deployment "us-east" {
  deployment_group = "north_america"
  inputs = {
    prefix    = "us-east"
  }
}

deployment "eu-de" {
  inputs = {
    prefix    = "eu-de"
  }
}

deployment "eu-es" {
  inputs = {
    prefix    = "eu-es"
  }
}