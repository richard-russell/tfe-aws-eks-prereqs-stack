# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "ami_ids" {
  description = "Map of architecture to AMI ID for the latest Hash base Ubuntu 24.04 image."
  value       = { for arch, ami in data.aws_ami.hc-base-ubuntu-2404 : arch => ami.id }
}

output "amd64_ami_id" {
  description = "AMI ID for the amd64 Hash base Ubuntu 24.04 image."
  value       = data.aws_ami.hc-base-ubuntu-2404["amd64"].id
}

output "arm64_ami_id" {
  description = "AMI ID for the arm64 Hash base Ubuntu 24.04 image."
  value       = data.aws_ami.hc-base-ubuntu-2404["arm64"].id
}
