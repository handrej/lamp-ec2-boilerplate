variable "vpc_id" {
  type = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to create"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file to use for SSH access"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed IPs for SSH access"
  type        = string
}
