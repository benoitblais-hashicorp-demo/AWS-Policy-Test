provider "aws" {
  # shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region = var.region
}
