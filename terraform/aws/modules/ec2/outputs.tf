output "ec2_ids" {
  value = aws_instance.lamp_ec2[*].id
}

output "ec2_public_ip" {
  value = aws_instance.lamp_ec2[*].public_ip
}
