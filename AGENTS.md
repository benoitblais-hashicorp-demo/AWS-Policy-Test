# AGENTS.md for Terraform Project

This file provides instructions for AI coding agents working on this Terraform Project.

## Project Overview

This project provisions AWS resources whose only purpose is to **test HCP Terraform policies** (Sentinel and/or Terraform Policy) against real plans. It is not a product or a demo application.

- The set of resources changes over time. Resources are added, modified, or removed depending on the policy being tested.
- Resources may be intentionally **compliant** or **non-compliant** with a policy, so that both the pass and fail paths can be exercised. Do not "fix" a resource that is non-compliant on purpose; check the request or the `docs/SPECIFICATION.md` test scenarios first.
- Runs are executed by HCP Terraform (VCS-driven). Policy sets are attached to the workspace and evaluated during the run.
- The configuration currently provisions a single AWS VPC (via the `terraform-aws-modules/vpc/aws` module), tagged with a dynamic `creation_date` tag.
- Resources are short-lived and should be destroyed when the test is finished (a NAT Gateway, for example, is billed hourly).

## Module and Repository Structure

This is a flat root module. There is no numbered or step-based file convention and no step gating variables.

```text
├── .gitignore
├── LICENSE
├── README.md
├── terraform.tf          # Terraform version and provider requirements
├── providers.tf          # Provider configurations
├── variables.tf          # Input variable definitions (alphabetical order)
├── locals.tf             # Random identifier, resource prefix, and common tags
├── main.tf               # Resources under test (currently the VPC)
├── outputs.tf            # Output value definitions (alphabetical order, created when needed)
├── docs/
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── README_footer.md
│   ├── README_header.md
│   ├── SECURITY.md
│   └── SPECIFICATION.md  # Test scenarios: which policy is tested and the expected result
```

### Adding or Changing Test Resources

- Keep `main.tf` for the core resources. When a new test needs a different AWS service, create a file named after the service or the topic (for example `s3.tf`, `security_groups.tf`, `ec2.tf`) instead of growing `main.tf`.
- Keep each test self-contained so that it can be removed by deleting a file (and its variables/outputs) without side effects on the others.
- Prefer small, cheap resources. Avoid resources that are costly or slow to create unless the policy under test requires them.
- Use input variables for values a policy may reasonably check (instance type, region, CIDR, encryption flags, and so on), so a test can be flipped between compliant and non-compliant without code changes.
- When a test is added or removed, update `docs/SPECIFICATION.md` (scenario, policy, expected result) and `docs/README_header.md`.

### Required Files and Directories

- `README.md` – Required in the root module. Generated automatically via terraform-docs CI. Do not edit manually.
- `docs/README_header.md` – Purpose of the repository, the resources currently deployed, permissions, and authentication.
- `docs/README_footer.md` – External documentation links used to develop the code.
- `docs/SPECIFICATION.md` – List of policy test scenarios and their expected outcomes.
- `terraform.tf` – Terraform version and provider requirements (`required_version`, `required_providers`).
- `providers.tf` – Provider configurations.
- `variables.tf` – Input variable definitions (alphabetical order with required variables at the top).
- `outputs.tf` – Output value definitions (alphabetical order).

## Tools and Frameworks

- Planning and applying are done by HCP Terraform through the VCS workflow. Never run `terraform plan`, `terraform apply`, or `terraform destroy` from the agent session.
- Running `terraform fmt`, and `terraform init -backend=false` followed by `terraform validate`, is allowed locally to check the code. Do not commit the generated `.terraform/` directory.
- Format and CI validation are also handled by the GitHub workflows (`terraform.yml`, `linter.yml`).
- Use `terraform-docs` to generate the `README.md` file using the header and footer (the CI does it, but the header/footer files must be kept up to date).

## README_header.md

When editing or creating `docs/README_header.md`, ensure it contains:

- A description of the general purpose of the code (testing HCP Terraform policies on AWS resources).
- A `Permissions` section containing the permissions required to provision the AWS resources.
- An `Authentications` section describing HCP Terraform AWS dynamic provider credentials.
- A `Test Components` section listing the resources currently managed and the policy each one is meant to exercise.

## README_footer.md

When editing or creating `docs/README_footer.md`, ensure it contains:

- An `External Documentation` section providing links to relevant external documentation used to develop the code (for example the AWS provider docs and HCP Terraform policy docs).

## Code Guidelines

Refer to CONTRIBUTING.md for general coding guidelines. HashiCorp's Terraform style guide should be applied for all code generated.

## Resource Naming

- Use descriptive nouns separated by underscores.
- Do not include the resource type in the resource name.
- Wrap resource type and name in double quotes.
- Example: `resource "aws_s3_bucket" "logs"` not `resource "aws_s3_bucket" "s3_logs"`.
- Prefix AWS resource names with `local.resources_prefix` so several deployments can coexist in the same AWS account.

## Tagging

- Every taggable resource must carry the `creation_date` tag, formatted `YYYY-MM-DD`.
- The date is generated dynamically from the `time_static.creation_date` resource and exposed through `local.tags` (see `locals.tf`). Do not hardcode a date.
- Apply `local.tags` through the `tags` argument of each resource or module. Do not redefine the tag elsewhere.
- Policies may check for this tag, so a resource without it is a deliberate test case and must be documented in `docs/SPECIFICATION.md`.

## Version Management

- Prefer the pessimistic constraint operator (`~>`) for modules and providers to allow safe updates within a compatible version range.
- Avoid using only the equals (`=`) operator unless you must lock to a single version for reproducibility or known issues.
- Pin the Terraform version using `required_version` in the `terraform` block.
- `.terraform.lock.hcl` is git-ignored; do not commit it.

## Provider Configuration

- Always include a default provider configuration.
- Define all providers in the same file (`providers.tf`).
- Define the default provider first, then aliased providers.
- Use `alias` as the first parameter in non-default provider blocks.
- Authentication is provided by HCP Terraform dynamic credentials; do not add static credentials to the provider block.

## Security and Secrets

- Never commit `.terraform` directories or local state files.
- The project uses HCP Terraform native dynamic credentials for AWS.
- Access secrets securely via workspace variables.
- Set `sensitive = true` for sensitive variables across all definitions.
- A non-compliant test resource must still not expose real data or be open to the world in a harmful way. Prefer a configuration that a policy can detect in the plan (for example an unencrypted but empty bucket) over one that creates real exposure.

## State Management

- State storage is managed natively by HCP Terraform workspaces. Data sharing between configurations relies on standard data sources or `tfe_outputs` where cross-workspace values are required.
