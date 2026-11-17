# Payment Processor Deployment

This repository contains a small Spring Boot application and an example AWS
deployment platform for running it on Amazon EKS with a private PostgreSQL
database. This submission focuses on containerization, infrastructure, Kubernetes
deployment, and delivery automation.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the architecture and the database
startup strategy.

## Repository layout

```text
.
├── .github/workflows/
│   ├── deploy.yml                 # Validation and production deployment
│   └── security.yml               # CodeQL, Gitleaks, tfsec, and Trivy
├── k8s/
│   ├── base/                      # Reusable application resources
│   ├── overlays/production/       # Production configuration and secrets
│   └── policies/kyverno/          # Admission policy for workload pods
├── src/                           # Spring Boot entry point
├── terraform/
│   ├── environments/production/   # Production Terraform root module
│   └── modules/                   # Network, EKS, database, IAM, and ECR
├── Dockerfile
└── ARCHITECTURE.md
```

## Components

- **Application and image:** Java 17 / Spring Boot, built with Maven in a
  multi-stage Docker build and run in a non-root distroless image.
- **Infrastructure:** Terraform provisions a VPC, private EKS cluster and node
  group, non-public Multi-AZ RDS PostgreSQL, Secrets Manager integration, and
  an immutable ECR repository.
- **Kubernetes:** Kustomize composes the shared application base with the
  production overlay. The deployment has three replicas, rolling updates,
  health probes, resource limits, a disruption budget, and a database
  readiness init container.
- **Secrets:** External Secrets Operator uses AWS workload identity to read
  the database secret from Secrets Manager and create the Kubernetes Secret
  consumed by the application.
- **Policy and CI security:** Kyverno enforces pod security requirements.
  GitHub Actions also runs CodeQL, Gitleaks, tfsec, Trivy scans, and generates
  CycloneDX SBOM artifacts.

## Prerequisites

For local validation, install:

- Java 17 and Maven
- Terraform
- `kubectl` with Kustomize support
- Docker with BuildKit

Production deployment additionally requires AWS CLI, Helm, `envsubst`, and
Trivy on the self-hosted GitHub Actions runner. That runner must be able to
reach the private EKS API from the VPC.

## Local validation

Run Maven tests and package the application:

```sh
mvn -B -ntp test
mvn -B -ntp package
```

Build the container image:

```sh
docker build -t payment-processor:local .
```

Check Terraform formatting and configuration without connecting to the
production state backend:

```sh
terraform fmt -check -recursive terraform
cd terraform/environments/production
terraform init -backend=false -input=false
terraform validate
cd ../../..
```

Render the production Kubernetes configuration:

```sh
kubectl kustomize k8s/overlays/production
```

The rendered output contains placeholders for deployment-time values. The
workflow supplies the image tag, database secret name, and AWS region; do not
apply the unrendered files directly to a cluster.

## Production setup and deployment

The workflow in [deploy.yml](./.github/workflows/deploy.yml) runs validation
for pull requests and deploys after a validated push to `main`. Before
enabling production deployment:

1. Bootstrap an encrypted S3 bucket for Terraform state and its locking
   mechanism. The bucket must exist before the workflow runs.
2. Configure a GitHub OIDC deploy role and its AWS trust and permission
   policies. Avoid long-lived AWS credentials.
3. Configure the GitHub `production` environment with the `AWS_DEPLOY_ROLE_ARN`
   and `TF_STATE_BUCKET` variables, and protect that environment with the
   appropriate reviewers and branch restrictions.
4. Ensure the self-hosted runner has the required tools and VPC connectivity.
5. Review the AWS region, EKS and PostgreSQL versions, CIDR ranges, instance
   sizes, permissions, and expected costs before provisioning.

The production workflow applies Terraform, pushes a commit-SHA-tagged image,
installs External Secrets Operator and Kyverno, then applies the Kustomize
production overlay. **Do not run `terraform apply` against a real account
without reviewing the configuration, state backend, IAM permissions, and
expected plan first.**

## Important operational notes

- Terraform state contains sensitive infrastructure data. Restrict access,
  enable encryption, and configure appropriate backup and recovery controls.
- The database is configured without a public address and accepts PostgreSQL
  traffic only from an approved EKS security group. Private subnet NAT routes
  may provide outbound access; they do not make the database publicly
  reachable.
- The application currently uses PostgreSQL `sslmode=require`. For strict
  server certificate and hostname verification, configure `verify-full` and
  provide the appropriate RDS CA trust.
- Pod topology spreading currently uses `ScheduleAnyway`, so distribution
  across nodes and zones is preferred but not guaranteed.
- Configure and test monitoring, alerting, database backup restoration,
  failover, secret rotation, and disaster recovery for the target environment.

## Security workflows

The deployment workflow scans Terraform/Kubernetes configuration and the
container image, and stores SBOMs as workflow artifacts. The separate
[security workflow](./.github/workflows/security.yml) runs CodeQL, Gitleaks,
tfsec, and Trivy filesystem scanning. Review workflow findings and keep action
versions, base images, dependencies, and policy chart versions current.
