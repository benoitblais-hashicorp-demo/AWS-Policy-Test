#------------------------------------------------------------------------------
# Required variables
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Optional variables
#------------------------------------------------------------------------------

variable "instance_type" {
  description = "(Optional) EC2 instance type."
  type        = string
  default     = "t3.medium"

  validation {
    condition = contains([
      "t3.medium",
      "t3.large",
      "t3.xlarge",
      "m6i.large",
      "m6i.xlarge",
      "m6a.large",
      "m6a.xlarge",
    ], var.instance_type)
    error_message = "`instance_type` must be one of: t3.medium, t3.large, t3.xlarge, m6i.large, m6i.xlarge, m6a.large, or m6a.xlarge."
  }
}

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