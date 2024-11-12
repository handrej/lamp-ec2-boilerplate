variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(any)
}

variable "public_subnets" {
  type = list(any)
}

variable "ec2_ids" {
  type = list(any)
}
