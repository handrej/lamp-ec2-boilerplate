# Target Group for ALB
resource "aws_lb_target_group" "lamp_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lamp_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-target-group"
  }
}

# ALB
resource "aws_lb" "lamp_lb" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public-subnet[*].id

  tags = {
    Name = "${var.project_name}-lb"
  }
}

# ALB Listener
resource "aws_lb_listener" "lamp_listener" {
  load_balancer_arn = aws_lb.lamp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lamp_tg.arn
  }
}

# Register EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(aws_instance.lamp_ec2)
  target_group_arn = aws_lb_target_group.lamp_tg.arn
  target_id        = element(aws_instance.lamp_ec2[*].id, count.index)
  port             = 80
}
