# outputs.tf
output "lb_dns_name" {
  value = module.lb.lb_dns_name
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}
