variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "security_group" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "instance_count" {
  description = "Total count of EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
}

variable "iam_ssm_role" {
  description = "IAM SSM Role Name"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to create"
  type        = string
}
