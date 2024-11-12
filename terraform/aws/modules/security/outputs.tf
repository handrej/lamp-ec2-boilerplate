output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "iam_ssm_role" {
  value = aws_iam_instance_profile.ssm_instance_profile.name
}
