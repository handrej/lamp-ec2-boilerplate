# RDS MySQL Instance
resource "aws_db_instance" "lamp_rds" {
  allocated_storage       = var.db_storage
  backup_retention_period = var.db_retention
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = var.security_groups
  db_subnet_group_name    = var.rds_subnet_group
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}

# Create SSM parameters for RDS
resource "aws_ssm_parameter" "db_endpoint" {
  name  = "rds_endpoint"
  type  = "String"
  value = aws_db_instance.lamp_rds.address
}

resource "aws_ssm_parameter" "db_username" {
  name  = "rds_username"
  type  = "String"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "rds_password"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_ssm_parameter" "db_name" {
  name  = "rds_database"
  type  = "String"
  value = var.db_name
}
