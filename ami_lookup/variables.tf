# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "architectures" {
  description = "List of CPU architectures to look up AMIs for."
  type        = list(string)
  default     = ["amd64", "arm64"]
}

variable "owner_account_id" {
  description = "AWS account ID that owns the AMIs (ami-prod account)."
  type        = string
  default     = "888995627335"
}
