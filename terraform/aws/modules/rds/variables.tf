variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "security_groups" {
  type = list(any)
}

variable "rds_subnet_group" {
  type = string
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
  sensitive   = true
}

variable "db_name" {
  description = "RDS MySQL default database name"
  type        = string
}
