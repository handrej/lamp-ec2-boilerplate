# outputs.tf

output "ec2_public_ip" {
  value = aws_instance.lamp_ec2.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.lamp_rds.endpoint
}

output "lb_dns" {
  value = aws_lb.lamp_lb.dns_name
}
