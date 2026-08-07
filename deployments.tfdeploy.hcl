# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

store "varset" "tfe_mushypea_secrets" {
  name     = "tfe_mushypea_secrets"
  category = "terraform"
}

store "varset" "tfe_pki" {
  name     = "sandbox_pki"
  category = "terraform"
}

locals {
  aws_region = "eu-west-1"

  # 3 private subnets (EKS nodes + RDS + Redis) and 3 public subnets (load balancers + bastion)
  private_subnet_cidrs = cidrsubnets(cidrsubnet("10.1.0.0/16", 4, 0), 4, 4, 4)
  public_subnet_cidrs  = cidrsubnets(cidrsubnet("10.1.0.0/16", 4, 1), 4, 4, 4)
}

deployment "development" {
  inputs = {
    aws_region           = local.aws_region
    role_arn             = "arn:aws:iam::363715248670:role/tfc-workload-identity-richard-russell-org"
    identity_token       = identity_token.aws.jwt
    common_tags          = { owner = "Richard Russell", stack = "tfe-eks" }
    friendly_name_prefix = "eks"
    tfe_fqdn             = "eks-tfe.richard-russell.sbx.hashidemos.io"

    vpc_cidr             = "10.1.0.0/16"
    private_subnet_cidrs = local.private_subnet_cidrs
    public_subnet_cidrs  = local.public_subnet_cidrs

    tfe_license             = store.varset.tfe_mushypea_secrets.stable.tfe_license
    tfe_encryption_password = store.varset.tfe_mushypea_secrets.stable.tfe_encryption_password
    tfe_database_password   = store.varset.tfe_mushypea_secrets.stable.tfe_database_password
    tfe_redis_password      = store.varset.tfe_mushypea_secrets.stable.tfe_redis_password

    tfe_tls_privkey   = store.varset.tfe_pki.stable.private_key_base64
    tfe_tls_cert      = store.varset.tfe_pki.stable.certificate_fullchain_base64
    tfe_tls_ca_bundle = store.varset.tfe_pki.stable.certificate_fullchain_base64
  }
}

publish_output "development_networks" {
  description = "VPC and subnet outputs from the development deployment."
  value       = deployment.development.networks
}

publish_output "development_secrets" {
  description = "Secret ARN outputs from the development deployment."
  value       = deployment.development.secrets
}

publish_output "development_pki" {
  description = "TLS/PKI secret ARN outputs from the development deployment."
  value       = deployment.development.pki
}
