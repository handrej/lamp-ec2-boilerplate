# variables.tf

variable "aws_region" {
  default = "eu-central-1"
}

variable "project_name" {
  description = "Name of the project"
  default     = "lamp-boilerplate"
}

variable "instance_count" {
  description = "Total count of EC2 instances"
  default     = 2
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "ami" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-00ec1ed16f4837f2f" # exclusive to eu-central-1
}

variable "instance_type" {
  description = "EC2 Free Tier Instance type"
  default     = "t2.micro"
}

variable "db_engine" {
  description = "RDS DB type"
  default     = "mysql"
}

variable "db_instance_class" {
  description = "RDS Free Tier Instance class"
  default     = "db.t3.micro"
}

variable "db_retention" {
  description = "Retention Period of RDS Backups"
  default     = 7
}

variable "db_storage" {
  description = "Free Tier Storage size in GB"
  default     = 20
}

variable "db_username" {
  description = "RDS MySQL master username"
  type        = string
}

variable "db_password" {
  description = "RDS MySQL master password"
  sensitive   = true
}

variable "db_name" {
  description = "RDS MySQL default database name"
  type        = string
  default     = "wordpressdb"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to create"
  default     = "main-ssh-key"
}

variable "public_key_path" {
  description = "Path to the public key file to use for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
