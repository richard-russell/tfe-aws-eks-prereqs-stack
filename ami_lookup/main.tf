# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Fetch the latest approved Hash base Ubuntu 24.04 AMI per architecture
data "aws_ami" "hc-base-ubuntu-2404" {
  for_each = toset(var.architectures)

  filter {
    name   = "name"
    values = [format("hc-base-ubuntu-2404-%s-*", each.value)]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  most_recent = true
  owners      = [var.owner_account_id] # ami-prod account
}
