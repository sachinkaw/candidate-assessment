terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "Terraform"
    }
  }
}

module "payment_platform" {
  source = "../../modules/payment-platform"

  name                    = "payment-processor"
  aws_region              = var.aws_region
  kubernetes_version      = var.kubernetes_version
  postgres_engine_version = var.postgres_engine_version
  deploy_role_arn         = var.deploy_role_arn
}
