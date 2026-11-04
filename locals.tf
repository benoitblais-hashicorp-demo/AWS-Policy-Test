# ==============================================================================
# LOCAL IDENTIFIERS
# ==============================================================================
# This file generates a randomized suffix to attach to the global prefix.
# This ensures that multiple instances of this deployment can securely run in the
# same AWS account without causing naming collisions (e.g., Load Balancers, VPCs).
# ==============================================================================

locals {
  global_id        = random_string.identifier.result
  resources_prefix = "${var.resources_prefix}-${local.global_id}"

  # Tags applied to all resources, creation_date formatted as YYYY-MM-DD
  tags = {
    creation_date = formatdate("YYYY-MM-DD", time_static.creation_date.rfc3339)
  }
}

# Captures the timestamp of the first apply and keeps it stable on later runs
resource "time_static" "creation_date" {}

# Generate a 4-character random lowercase string (e.g., 'a1b2')
resource "random_string" "identifier" {
  length  = 4
  special = false
  numeric = false
  upper   = false
}