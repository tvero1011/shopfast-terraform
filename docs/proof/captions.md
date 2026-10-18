# Deployment proof

Deployed from scratch on 17 October 2026 in us-east-1, verified, and destroyed the same day. Account IDs are redacted.

| # | Screenshot | What it shows |
|---|---|---|
| 01 | `01-bootstrap-bucket.png` | Bootstrap created the encrypted, versioned S3 state bucket (4 resources) |
| 02 | `02-remote-state-init.png` | `terraform init` configured the S3 backend |
| 03 | `03-ecr-repository.png` | ECR repository created by `terraform apply -target` |
| 04 | `04-ecr-images.png` | First container image pushed to ECR |
| 05 | `05-apply-complete.png` | Full `terraform apply`: 49 resources added |
| 06 | `06-api-online.png` | API reachable through the load balancer |
| 07 | `07-track-database-connected.png` | `/track/123` returns `database_connected: true` |
| 08 | `08-ecs-service-healthy.png` | ECS service: 2 running tasks, 2 healthy targets |
| 09 | `09-autoscaling.png` | CPU target-tracking policy (min 2, max 4, target 60%) |
| 10 | `10-cloudwatch-alarms.png` | The 5 Terraform-managed CloudWatch alarms (plus autoscaling's own) |
| 11 | `11-pipeline-deployed-commit-sha.png` | ECS task definition running the commit-SHA image built by GitHub Actions (OIDC login, ECR push, ECS rollout) |
| 11b | `11b-github-actions-green-runs.png` | Both workflows green on `main`: Build and deploy app, Terraform checks |
| 11c | `11c-ecs-deployments-new-revision.png` | ECS service on task definition revision 7 (the pipeline's commit-SHA image): 2 running, 0 pending, deployment status Success |
| 12 | `12-pr-plan-check-first-run.png` | First PR plan check failed (read-only role could not write the S3 lock file) (historical: this PR plan check was later removed) |
| 13 | `13-pr-plan-lock-error.png` | The 403 AccessDenied on the `.tflock` key that explained the failure (historical: this PR plan check was later removed) |
| 14 | `14-pr-plan-check-green.png` | After scoped fixes (lock-file permission, `github_repo` variable, DB secret read), the plan check passes (historical: this PR plan check was later removed) |
| 15 | `15-pr-plan-output.png` | Plan step of the passing PR check: `No changes. Your infrastructure matches the configuration.` (password never printed) (historical: this PR plan check was later removed) |
| 16 | `16-rds-private-encrypted.png` | RDS PostgreSQL: `PubliclyAccessible: False`, `Encrypted: True` (single-AZ, db.t4g.micro) |
| 17 | `17-vpc-endpoints.png` | The 5 VPC endpoints, all Available: 4 interface (ecr.api, ecr.dkr, logs, secretsmanager) and 1 S3 gateway |
| 18 | `18-no-nat-gateway.png` | NAT gateways page: none found, private subnets reach AWS services through endpoints only |
| 19 | `19-security-group-chain.png` | Security group chain: internet to ALB (80), ALB SG to Fargate SG (3000), Fargate SG to RDS SG (5432); endpoints accept 443 from the VPC only |
| 20 | `20-terraform-destroy-complete.png` | `terraform destroy` finished: 53 resources destroyed, nothing left running (only the state bucket remains) |

**About the resource counts.** The first full `terraform apply` added 49 resources. With the ECR repository (created first with `-target`) and two inline policies added to the plan role while fixing the PR check, the stack held 53 resources when it was destroyed. The plan role was removed afterwards, so a fresh deploy creates fewer resources than this.

**About rows 12-15 (historical).** Earlier I ran `terraform plan` on pull requests with a read-only AWS role. It failed three times before it passed: the role could not write the S3 lock file, `github_repo` had no value in CI because `terraform.tfvars` is gitignored, and plan could not read the DB secret because `ReadOnlyAccess` excludes it. Each was fixed with a scoped change. After a security review I removed the plan role and the plan job: read-only access can still read Terraform state, which holds the DB password. Pull-request checks now run `fmt`, `init -backend=false` and `validate` with no AWS credentials. These screenshots are kept as debugging history.

## Key screenshots

![API online](06-api-online.png)
![Tracking endpoint](07-track-database-connected.png)
![Green workflow runs](11b-github-actions-green-runs.png)
![Security group chain](19-security-group-chain.png)
