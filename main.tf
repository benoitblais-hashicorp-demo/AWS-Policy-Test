# ==============================================================================
# NETWORKING
# ==============================================================================
# This file provisions a single AWS Virtual Private Cloud (VPC) used to test
# HCP Terraform policies.
# ==============================================================================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    { Name = "${local.resources_prefix}-vpc" },
    local.tags
  )
}
