# network.tf

# vpc.tf

resource "aws_vpc" "lamp_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# First public subnet in the original AZ
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.lamp_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

# Second public subnet in a different AZ
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.lamp_vpc.id
  cidr_block              = var.public_subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"
  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

# First private subnet in the original AZ
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.lamp_vpc.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.project_name}-private-subnet-1"
  }
}

# Second private subnet in a different AZ
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.lamp_vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.project_name}-private-subnet-2"
  }
}


# RDS subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.project_name}-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

# networking.tf

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lamp_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public route table to allow access from the internet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.lamp_vpc.id

  # Route for Internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate the first public subnet with the public route table
resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the second public subnet with the public route table
resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# lb.tf

resource "aws_lb" "lamp_lb" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id]
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]

  tags = {
    Name = "${var.project_name}-lb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lamp_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.lamp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Only one single instance in one AZ.
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.lamp_ec2.id
  port             = 80
}
