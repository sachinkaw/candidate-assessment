locals {
  common_tags = merge(var.tags, {
    ManagedBy   = "Terraform"
    Application = var.name
  })
}

module "network" {
  source = "../network"

  name     = var.name
  vpc_cidr = var.vpc_cidr
  tags     = local.common_tags
}

module "eks" {
  source = "../eks"

  name               = var.name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.network.private_subnet_ids
  deploy_role_arn    = var.deploy_role_arn
  tags               = local.common_tags
}

module "database" {
  source = "../database"

  name                           = var.name
  postgres_engine_version        = var.postgres_engine_version
  database_name                  = var.database_name
  database_username              = var.database_username
  database_secret_name           = var.database_secret_name
  database_instance_class        = var.database_instance_class
  database_allocated_storage     = var.database_allocated_storage
  database_max_allocated_storage = var.database_max_allocated_storage
  vpc_id                         = module.network.vpc_id
  subnet_ids                     = module.network.private_subnet_ids
  allowed_security_group_ids     = [module.eks.cluster_security_group_id]
  tags                           = local.common_tags
}

module "external_secrets_iam" {
  source = "../external-secrets-iam"

  name                = var.name
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  database_secret_arn = module.database.secret_arn
  tags                = local.common_tags
}

module "registry" {
  source = "../registry"

  name = var.name
  tags = local.common_tags
}
