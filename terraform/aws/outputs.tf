# outputs.tf

output "lb_dns" {
  value       = aws_lb.lamp_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}
