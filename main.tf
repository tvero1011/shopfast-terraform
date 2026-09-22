# ---------------------------------------------------------
# 1. Network Foundation (VPC, subnets, routing, endpoints, SGs)
# ---------------------------------------------------------
module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# ---------------------------------------------------------
# 2. Artifact Storage (the Docker image registry)
# ---------------------------------------------------------
module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

# ---------------------------------------------------------
# 3. Database + Secrets Manager
# RDS trusts the Fargate SG that lives in the VPC module. The ECS module
# uses that SAME SG, which also avoids a circular dependency
# (rds needs the SG, ecs needs the rds address).
# ---------------------------------------------------------
module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.vpc.fargate_security_group_id
}

# ---------------------------------------------------------
# 4. Traffic entry point (Application Load Balancer)
# ---------------------------------------------------------
module "alb" {
  source                = "./modules/alb"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
}

# ---------------------------------------------------------
# 5. Compute (ECS Fargate service + autoscaling)
# depends_on alb: the target group must be attached to a listener
# before a service can register with it.
# ---------------------------------------------------------
module "ecs" {
  source                    = "./modules/ecs"
  region                    = var.region
  project_name              = var.project_name
  private_subnet_ids        = module.vpc.private_subnet_ids
  fargate_security_group_id = module.vpc.fargate_security_group_id
  target_group_arn          = module.alb.target_group_arn
  ecr_repository_url        = module.ecr.repository_url
  db_instance_address       = module.rds.db_instance_address
  db_name                   = module.rds.db_name
  db_username               = module.rds.db_username
  db_password_secret_arn    = module.rds.db_password_secret_arn

  depends_on = [module.alb]
}

# ---------------------------------------------------------
# 6. CI/CD identity (GitHub Actions assumes this role via OIDC, no stored keys)
# ---------------------------------------------------------
module "github_oidc" {
  source                 = "./modules/github_oidc"
  project_name           = var.project_name
  github_repo            = var.github_repo
  github_branch          = var.github_branch
  create_oidc_provider   = var.create_github_oidc_provider
  ecr_repository_arn     = module.ecr.repository_arn
  ecs_service_arn        = module.ecs.service_arn
  ecs_execution_role_arn = module.ecs.execution_role_arn
}

# ---------------------------------------------------------
# 7. Alarms: ECS CPU, ALB 5xx/unhealthy hosts, RDS CPU/storage -> one SNS topic
# ---------------------------------------------------------
module "cloudwatch" {
  source                  = "./modules/cloudwatch"
  project_name            = var.project_name
  alert_email             = var.alert_email
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  db_instance_id          = module.rds.db_instance_id
}
