# Contributing

Thank you for your interest in contributing. This repository uses Terraform to provision AWS resources that are used to test HCP Terraform policies. The resources change over time depending on the policy being tested. Please review these guidelines before contributing.

## Architecture Paradigm: HCP Terraform Workspaces

This project leverages standard Terraform configurations and uses HCP Terraform workspaces for remote execution and state management.

* **No Local State or CLI Applies:** Do not run `terraform apply` locally. All pushes to the main branch are evaluated and deployed by HCP Terraform natively via a VCS-driven workflow.
* **State Management:** Data sharing between distinct configurations relies on standard data sources or workspace output patterns where cross-workspace values are required.
* **Dynamic Credentials:** The project leverages dynamic provider credentials natively supported by Terraform Cloud/Enterprise.

## Development Workflow

1. **Fork & Branch:** Create a branch for your feature or bug fix.
2. **Write Code:** Modify the Terraform configurations. Put resources for a new AWS service in their own file (for example `s3.tf`) so a test can be removed by deleting the file. Follow the styling guidelines in AGENTS.md.
3. **Keep Tests Independent:** A test resource must not depend on resources from another test. Use variables for values a policy may check, so a scenario can be switched between compliant and non-compliant.
4. **Tag Resources:** Apply `local.tags` (which contains the dynamic `creation_date` tag) to every taggable resource, unless the missing tag is the scenario being tested.
5. **Document the Scenario:** Add or update the scenario (policy, resource, expected result) in `docs/SPECIFICATION.md`, and update `docs/README_header.md`.
6. **Format:** Formatting checks are enforced by CI/CD. The `terraform.yml` workflow runs `terraform fmt` and pushes fixes automatically on pull requests.
7. **Open a Pull Request:** Fill out the provided PR template outlining your changes.

## Code Guidelines

* **Minimalism:** Favor readability and simplicity over highly complex abstractions.
* **Variable Descriptions:** Every variable must have a clear `description` and `type`. Prefix descriptions with `(Required)` or `(Optional)`.
* **Version Constraints:** Use the pessimistic operator (`~>`) for provider and module versions to ensure stability without strict lock-in. Pin the Terraform version using `required_version` in the `terraform` block.
* **Naming Conventions:** Use `snake_case` for all resource and variable names. Avoid including the resource type in the name (i.e., `resource "aws_s3_bucket" "logs"`, not `resource "aws_s3_bucket" "s3_logs"`).
* **Outputs:** Keep outputs alphabetical. Use concise factual descriptions without `(Required)`/`(Optional)` prefixes.

## Security Check

* Never commit `.terraform` folders, `.tfstate` files, or `.tfvars` files containing actual secrets.
* Never commit AWS credentials, API keys, or any plaintext credentials.
* Access secrets securely via workspace variables. Set `sensitive = true` for sensitive variables across all definitions.

If you find a security vulnerability, please refer to our `SECURITY.md` for reporting procedures.

## Documentation

* **Auto-generated README:** Do not edit `README.md` directly. It is generated automatically by `terraform-docs` via GitHub Actions CI. To modify the README content, edit `docs/README_header.md` or `docs/README_footer.md` instead.
