# AWS Policy Test

## Purpose

This repository provisions AWS resources whose only purpose is to **test HCP Terraform policies** against real Terraform plans. The resources are intentionally simple and short-lived, and they change over time depending on the policy being tested. Some resources may be non-compliant on purpose, so that both the pass and the fail outcomes of a policy can be observed.

## Permissions

The identity used by HCP Terraform must be allowed to manage the resources currently deployed (see [Test Components](#test-components)). For the VPC, this means at minimum:

- **AWS:**
  - Create, modify, and delete VPCs, subnets, route tables, route table associations, Internet Gateways, NAT Gateways, Elastic IPs, and default network resources (`ec2:*` actions on these resource types).
  - Create and delete tags (`ec2:CreateTags`, `ec2:DeleteTags`).
  - Read Availability Zones and instance type offerings (`ec2:DescribeAvailabilityZones`, `ec2:DescribeInstanceTypeOfferings`).

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
| `module.vpc` | `main.tf` | AWS VPC with private and public subnets in up to 3 Availability Zones, and a single NAT Gateway. |

Every resource receives the `creation_date` tag through `local.tags`.

The policy scenarios and their expected results are listed in [`docs/SPECIFICATION.md`](docs/SPECIFICATION.md).

## How to Use

1. Create an HCP Terraform workspace connected to this repository, and attach the policy set to be tested.
2. Configure the AWS dynamic credentials variables described above.
3. Optionally set the input variables (`region`, `resources_prefix`, `vpc_cidr`, `instance_type`) to switch a scenario between compliant and non-compliant.
4. Trigger a run and review the policy check results.
5. Destroy the resources when the test is finished (the NAT Gateway is billed hourly).
