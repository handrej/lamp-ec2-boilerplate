data "aws_ami" "linux_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] #canonical
}

# Launch EC2 Instances
resource "aws_instance" "lamp_ec2" {
  count                  = var.instance_count
  ami                    = data.aws_ami.linux_latest.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = element(var.public_subnets, count.index)
  vpc_security_group_ids = [var.security_group]
  iam_instance_profile   = var.iam_ssm_role

  tags = {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  }
}

