# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in."
}

variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources. Must not contain 'tfe'."
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "role_arn" {
  type        = string
  description = "ARN of IAM role to assume via workload identity."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR ranges to create in the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR ranges to create in the VPC."
}

variable "tfe_fqdn" {
  type        = string
  description = "Fully qualified domain name (FQDN) of TFE instance."
}

# --- Secrets --- #
variable "tfe_license" {
  type        = string
  description = "Raw contents of the TFE license file."
  sensitive   = true
}

variable "tfe_encryption_password" {
  type        = string
  description = "TFE encryption password."
  sensitive   = true
}

variable "tfe_database_password" {
  type        = string
  description = "TFE database password."
  sensitive   = true
}

variable "tfe_redis_password" {
  type        = string
  description = "TFE Redis password (16–128 alphanumeric chars, no @, \", /)."
  sensitive   = true
}

# --- TLS certs --- #
variable "tfe_tls_privkey" {
  type        = string
  description = "Base64-encoded TFE TLS private key in PEM format."
  sensitive   = true
}

variable "tfe_tls_cert" {
  type        = string
  description = "Base64-encoded TFE TLS certificate (full chain) in PEM format."
  sensitive   = true
}

variable "tfe_tls_ca_bundle" {
  type        = string
  description = "Base64-encoded TFE TLS CA bundle in PEM format."
  sensitive   = true
}
