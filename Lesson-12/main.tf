provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Owner     = "Andrei Belyi"
      CreatedBy = "Terraform"
      Course    = "Terraform from zero to Certified Professional"
    }
  }
}
#------------------
data "aws_availability_zones" "working" {}
data "aws_ami" "latest_alinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }
}
#-----------------

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}
#------------------
resource "aws_security_group" "web" {
  name        = "Dynamic SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web Security Group"
  }
}
#------------------
resource "aws_launch_template" "web" {
  name                   = "WebServer-HA-LT"
  image_id               = data.aws_ami.latest_alinux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("${path.module}/user_data.sh")


}

#------------------

resource "aws_autoscaling_group" "web" {
  name                = "WebServer-HA-ASG-Ver-${aws_launch_template.web.latest_version}"
  min_size            = 2
  max_size            = 2
  min_elb_capacity    = 2
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers      = [aws_lb_target_group.web.arn]


  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      Name    = "WebServer in ASG-v${aws_launch_template.web.latest_version}"
      Owner   = "Andrei Belyi"
      TAGKEY  = "TAGVALUE"
      Project = "DevOps"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }

  }
  lifecycle {
    create_before_destroy = true
  }
}
#------------------

resource "aws_lb" "web" {
  name               = "WebServer-HighlyAvailable-ALB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}

resource "aws_lb_target_group" "web" {
  name                 = "Web-TG"
  vpc_id               = aws_default_vpc.default.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#------------------


output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}
