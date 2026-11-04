#------------------------------------------------------------------------------
# Required variables
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Optional variables
#------------------------------------------------------------------------------

variable "region" {
  description = "(Optional) AWS region where all resources are provisioned."
  type        = string
  default     = "ca-central-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "`region` must be a valid AWS region identifier (e.g. ca-central-1, eu-central-1)."
  }
}

variable "resources_prefix" {
  description = "(Optional) Prefix applied to all resources."
  type        = string
  default     = "policies"
}

variable "vpc_cidr" {
  description = "(Optional) IPv4 CIDR block for the AWS VPC."
  type        = string
  default     = "10.1.0.0/16"
}