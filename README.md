# AWS-Policy-Test
Code use to test HCP Terraform policy on AWS ressources.

<!-- BEGIN_TF_DOCS -->
# AWS Policy Test

## Purpose

This repository provisions AWS resources whose only purpose is to **test HCP Terraform policies** against real Terraform plans. The resources are intentionally simple and short-lived, and they change over time depending on the policy being tested. Some resources may be non-compliant on purpose, so that both the pass and the fail outcomes of a policy can be observed.

## Permissions

The identity used by HCP Terraform must be allowed to manage the resources currently deployed (see [Test Components](#test-components)). For the VPC, this means at minimum:

- **AWS:**
  - Create, modify, and delete VPCs (`ec2:CreateVpc`, `ec2:ModifyVpcAttribute`, `ec2:DeleteVpc`, `ec2:DescribeVpcs`, `ec2:DescribeVpcAttribute`).
  - Create and delete tags (`ec2:CreateTags`, `ec2:DeleteTags`).

Add the permissions required by any new resource type introduced for a test.

## Authentications

- **AWS:** HCP Terraform [dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration). Set the following workspace environment variables:
  - `TFC_AWS_PROVIDER_AUTH` = `true`
  - `TFC_AWS_RUN_ROLE_ARN` = ARN of the IAM role that HCP Terraform assumes

No static AWS credentials are stored in the code or in the workspace.

## Test Components

| Resource | File | Description |
| --- | --- | --- |
| `random_string.identifier` | `locals.tf` | 4-character lowercase suffix appended to the resource prefix to avoid naming collisions. |
| `time_static.creation_date` | `locals.tf` | Timestamp recorded on the first apply and kept stable on later runs. Source of the `creation_date` tag (`MM/DD/YYYY`). |
| `aws_vpc.main` | `main.tf` | AWS VPC. |

Every resource receives the `creation_date` tag through `local.tags`.

The policy scenarios and their expected results are listed in [`docs/SPECIFICATION.md`](docs/SPECIFICATION.md).

## How to Use

1. Create an HCP Terraform workspace connected to this repository, and attach the policy set to be tested.
2. Configure the AWS dynamic credentials variables described above.
3. Optionally set the input variables (`region`, `resources_prefix`, `vpc_cidr`) to switch a scenario between compliant and non-compliant.
4. Trigger a run and review the policy check results.
5. Destroy the resources when the test is finished.

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 6.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.8.1)

- <a name="requirement_time"></a> [time](#requirement\_time) (0.13.1)

## Modules

No modules.

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_region"></a> [region](#input\_region)

Description: (Optional) AWS region where all resources are provisioned.

Type: `string`

Default: `"ca-central-1"`

### <a name="input_resources_prefix"></a> [resources\_prefix](#input\_resources\_prefix)

Description: (Optional) Prefix applied to all resources.

Type: `string`

Default: `"policies"`

### <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr)

Description: (Optional) IPv4 CIDR block for the AWS VPC.

Type: `string`

Default: `"10.1.0.0/16"`

## Resources

The following resources are used by this module:

- [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (resource)
- [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/3.8.1/docs/resources/string) (resource)
- [time_static.creation_date](https://registry.terraform.io/providers/hashicorp/time/0.13.1/docs/resources/static) (resource)

## Outputs

No outputs.

<!-- markdownlint-enable -->
## External Documentation

- [HCP Terraform policy enforcement](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement)
- [HCP Terraform dynamic provider credentials for AWS](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration)
- [Terraform AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform time provider - `time_static`](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static)
- [Terraform random provider - `random_string`](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)
- [Terraform AWS provider - `aws_vpc`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
<!-- END_TF_DOCS -->