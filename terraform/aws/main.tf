provider "aws" {
  #region = var.aws_region
}

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source           = "./modules/security"
  project_name     = var.project_name
  vpc_id           = module.network.vpc_id
  key_pair_name    = var.key_pair_name
  public_key_path  = var.public_key_path
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "lb" {
  source          = "./modules/lb"
  project_name    = var.project_name
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  security_groups = [module.security.lb_sg_id]
  ec2_ids         = module.ec2.ec2_ids
}

module "rds" {
  source            = "./modules/rds"
  project_name      = var.project_name
  security_groups   = [module.security.rds_sg_id]
  rds_subnet_group  = module.network.rds_subnet_group
  db_engine         = var.db_engine
  db_instance_class = var.db_instance_class
  db_retention      = var.db_retention
  db_name           = var.db_name
  db_storage        = var.db_storage
  db_username       = var.db_username
  db_password       = var.db_password
}

module "ec2" {
  source         = "./modules/ec2"
  project_name   = var.project_name
  instance_count = var.instance_count
  instance_type  = var.instance_type
  public_subnets = module.network.public_subnets
  security_group = module.security.ec2_sg_id
  iam_ssm_role   = module.security.iam_ssm_role
  key_pair_name  = var.key_pair_name
}
