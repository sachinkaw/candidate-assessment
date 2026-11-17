# Terraform modules

The `payment-platform` module is the opinionated composition used by
`environments/production`. The child modules can also be called directly:

| Module | Responsibility | Main inputs |
| --- | --- | --- |
| `network` | VPC, public/private subnets, per-AZ NAT, and private Secrets Manager endpoint | `name`, `vpc_cidr`, optional `availability_zone_count`, `tags` |
| `eks` | Private EKS API, managed node group, add-ons, deploy-role access, and OIDC provider | `name`, `kubernetes_version`, private `subnet_ids`, `deploy_role_arn`, `tags` |
| `database` | Private encrypted Multi-AZ PostgreSQL and generated credentials in Secrets Manager | VPC/subnet IDs, allowed security groups, engine/size settings, database names |
| `external-secrets-iam` | IRSA role with access limited to one database secret | EKS OIDC provider, one secret ARN, `name`, `tags` |
| `registry` | Immutable, scanned ECR repository and lifecycle policy | repository `name`, `tags` |

The child modules intentionally accept IDs and security-group allowlists rather
than looking up platform-specific resources. This allows callers to use an
existing VPC, cluster, or secret. The `payment-platform` composition wires
module outputs together and preserves the network/database/cluster security
boundary for this assessment.
