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

  # Tags applied to all resources, creation_date formatted as MM/DD/YYYY
  tags = {
    #creation_date = formatdate("MM/DD/YYYY", time_static.creation_date.rfc3339)
    creation_date = "11/04/2026"
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