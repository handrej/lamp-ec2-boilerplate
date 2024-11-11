# Launch EC2 Instances
resource "aws_instance" "lamp_ec2" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = element(aws_subnet.public-subnet[*].id, count.index)
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "lamp_rds" {
  allocated_storage       = var.db_storage
  backup_retention_period = var.db_retention
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "${var.project_name}-rds"
  }
}
