# ---------------------------------------------------------
# 1. Network Foundation (VPC, Subnets, IGW)
# ---------------------------------------------------------
module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# ---------------------------------------------------------
# 2. Artifact Storage (The Docker Warehouse)
# ---------------------------------------------------------
module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

# ---------------------------------------------------------
# 3. Database & Security (RDS + Secrets Manager)
# ---------------------------------------------------------
module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  # FIX: Get the SG from the VPC module instead of the ECS module
  ecs_sg_id          = module.vpc.fargate_security_group_id #RDS allows traffic FROM ECS
}

# ---------------------------------------------------------
# 4. Traffic Control (Load Balancer)
# ---------------------------------------------------------
module "alb" {
  source                = "./modules/alb"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id # Ensure this matches the variable name in alb/variables.tf
}

# ---------------------------------------------------------
# 5. Compute (The App Containers)
# ---------------------------------------------------------
module "ecs" {
  source = "./modules/ecs"
  region = var.region
  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  alb_security_group_id  = module.vpc.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
  ecr_repository_url     = module.ecr.repository_url
  db_instance_address    = module.rds.db_instance_address
  db_password_secret_arn = module.rds.db_password_secret_arn # Updated: now coming from RDS module
}