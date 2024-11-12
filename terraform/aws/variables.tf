# variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "instance_count" {
  description = "Total count of EC2 instances"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "allowed_ssh_cidr" {
  description = "Allowed IPs for SSH access"
  type        = string
}

variable "db_engine" {
  description = "RDS DB type"
  type        = string
}

variable "db_instance_class" {
  description = "RDS Instance class"
  type        = string
}

variable "db_retention" {
  description = "Retention Period of RDS Backups"
  type        = string
}
variable "db_name" {
  description = "RDS MySQL default database name"
  type        = string
}

variable "db_storage" {
  description = "RDS Storage size in GB"
  type        = string
}

variable "db_username" {
  description = "RDS MySQL master username"
  type        = string
}

variable "db_password" {
  description = "RDS MySQL master password"
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to Create"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file to use for SSH access"
  type        = string
  sensitive   = true
}
