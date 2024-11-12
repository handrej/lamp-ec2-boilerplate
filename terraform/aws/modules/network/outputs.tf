output "vpc_id" {
  value = aws_vpc.lamp_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public-subnet[*].id
}

output "private_subnets" {
  value = aws_subnet.private-subnet[*].id
}

output "rds_subnet_group" {
  value = aws_db_subnet_group.rds_subnet_group.name
}
