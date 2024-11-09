# variables.tf

variable "project_name" {
  description = "Name of the project"
  default     = "lamp-boilerplate"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  default     = "10.0.4.0/24"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-00ec1ed16f4837f2f"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "db_username" {
  description = "RDS MySQL master username"
  default     = "<DB_USERNAME>"
}

variable "db_password" {
  description = "RDS MySQL master password"
  default     = "<DB_PASSWORD>"
}

variable "db_name" {
  description = "Database name"
  default     = "wordpress_db"
}
