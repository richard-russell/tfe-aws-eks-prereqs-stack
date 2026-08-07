# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

component "tfe-aws-prereqs" {
  source  = "app.terraform.io/richard-russell-org/hvd-module-prereqs/aws"
  version = "1.0.0"

  inputs = {
    friendly_name_prefix = var.friendly_name_prefix
    common_tags          = var.common_tags
    region               = var.aws_region

    # --- Networking --- #
    create_vpc           = true
    vpc_cidr             = var.vpc_cidr
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs  = var.public_subnet_cidrs

    # --- Bastion --- #
    create_bastion              = true
    bastion_cidr_allow_ingress_ssh = ["0.0.0.0/0"]

    # --- TFE Secrets Manager --- #
    tfe_license_secret_value             = var.tfe_license
    tfe_encryption_password_secret_value = var.tfe_encryption_password
    tfe_database_password_secret_value   = var.tfe_database_password
    tfe_redis_password_secret_value      = var.tfe_redis_password

    # --- TLS certs --- #
    tfe_tls_privkey_secret_value_base64   = var.tfe_tls_privkey
    tfe_tls_cert_secret_value_base64      = var.tfe_tls_cert
    tfe_tls_ca_bundle_secret_value_base64 = var.tfe_tls_ca_bundle

    # --- CloudWatch Log Group --- #
    create_cloudwatch_log_group = true
    cloudwatch_log_group_name   = "${var.friendly_name_prefix}-tfe-log-fwd"
  }

  providers = {
    aws    = provider.aws.this
    local  = provider.local.this
    random = provider.random.this
    tls    = provider.tls.this
  }
}

# --- Network outputs (published to downstream stack) --- #
output "networks" {
  description = "VPC and subnet IDs created by prereqs module."
  value = {
    vpc_id             = component.tfe-aws-prereqs.vpc_id
    private_subnet_ids = component.tfe-aws-prereqs.private_subnet_ids
    public_subnet_ids  = component.tfe-aws-prereqs.public_subnet_ids
  }
  type = object({
    vpc_id             = string
    private_subnet_ids = optional(list(string))
    public_subnet_ids  = optional(list(string))
  })
}

# --- Secret ARN outputs (published to downstream stack) --- #
output "secrets" {
  description = "Secret ARNs created by prereqs module."
  value = {
    tfe_license_secret_arn             = component.tfe-aws-prereqs.tfe_license_secret_arn
    tfe_encryption_password_secret_arn = component.tfe-aws-prereqs.tfe_encryption_password_secret_arn
    tfe_database_password_secret_arn   = component.tfe-aws-prereqs.tfe_database_password_secret_arn
    tfe_redis_password_secret_arn      = component.tfe-aws-prereqs.tfe_redis_password_secret_arn
  }
  type = object({
    tfe_license_secret_arn             = optional(string)
    tfe_encryption_password_secret_arn = optional(string)
    tfe_database_password_secret_arn   = optional(string)
    tfe_redis_password_secret_arn      = optional(string)
  })
}

# --- PKI outputs (published to downstream stack) --- #
output "pki" {
  description = "TLS secret ARNs created by prereqs module."
  value = {
    tfe_tls_privkey_secret_arn   = component.tfe-aws-prereqs.tfe_tls_privkey_secret_arn
    tfe_tls_cert_secret_arn      = component.tfe-aws-prereqs.tfe_tls_cert_secret_arn
    tfe_tls_ca_bundle_secret_arn = component.tfe-aws-prereqs.tfe_tls_ca_bundle_secret_arn
  }
  type = object({
    tfe_tls_privkey_secret_arn   = optional(string)
    tfe_tls_cert_secret_arn      = optional(string)
    tfe_tls_ca_bundle_secret_arn = optional(string)
  })
}

# --- Bastion outputs (convenience) --- #
output "bastion_public_dns" {
  value       = component.tfe-aws-prereqs.bastion_public_dns
  type        = string
  description = "Public DNS name of bastion EC2 instance."
}

output "bastion_public_ip" {
  value       = component.tfe-aws-prereqs.bastion_public_ip
  type        = string
  description = "Public IP of bastion EC2 instance."
}
