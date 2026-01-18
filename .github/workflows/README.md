# GitHub Actions Workflows

This directory contains GitHub Actions workflows for CI/CD automation.

## Workflows

### terraform-ci.yml

Comprehensive Terraform CI pipeline that runs on pull requests and pushes to main.

**Triggers:**
- Pull requests modifying `.tf` or `.tfvars` files
- Pushes to `main` branch

**Jobs:**

1. **terraform-format** - Format validation
   - Checks code formatting with `terraform fmt`
   - Comments on PR if issues found
   - Blocks merge on failure

2. **terraform-validate** - Syntax validation
   - Validates all apps and modules
   - Matrix job for parallel execution
   - Blocks merge on failure

3. **tflint** - Static analysis
   - Lints code using TFLint
   - Configured via `.tflint.hcl`
   - Blocks merge on failure

4. **tfsec** - Security scanning
   - Scans for security vulnerabilities
   - Uploads SARIF to GitHub Security
   - Warning only (soft-fail)

5. **checkov** - Compliance checks
   - Policy and compliance validation
   - Uploads SARIF to GitHub Security
   - Warning only (soft-fail)

6. **terraform-docs** - Documentation
   - Validates module documentation
   - Ensures README is up-to-date
   - Blocks merge on failure

7. **module-tests** - Module validation
   - Tests module examples
   - Blocks merge on failure

8. **summary** - Results aggregation
   - Creates summary table
   - Fails if required checks fail

## Local Testing

Run the same checks locally:

```bash
# Run all checks
make ci-local

# Run individual checks
make fmt-check
make validate
make lint
make security
make docs
make test
```

## Security Results

Security scan results are available in:
- GitHub Security tab (SARIF uploads)
- PR comments (summary)
- Action logs (detailed output)

## Customization

### Adding a New Check

1. Add job to `terraform-ci.yml`
2. Add to `summary` job dependencies
3. Add make target for local testing
4. Update this README

### Modifying Existing Checks

Edit the workflow file and update tool configurations:
- TFLint: `.tflint.hcl`
- Pre-commit: `.pre-commit-config.yaml`
- Make: `Makefile`

## Permissions

The workflow requires:
- `contents: read` - Read repository contents
- `pull-requests: write` - Comment on PRs

## Dependencies

- Terraform ~1.0
- TFLint (latest)
- tfsec (latest)
- Checkov (latest)
- terraform-docs (latest)
