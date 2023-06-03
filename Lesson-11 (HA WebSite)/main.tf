#---
# Provision Highly Available Web, default VPC
# Create:
#   - Security Group for Web Server
#   - Launch Configuration with Auto AMI Lookup
#   - ASG using 2 AZ
#   - CLB in 2 AZ
#
# Lesson by Denis Astahov, studied by Andrei Belyi
#---

provider "aws" {
  region = "us-east-2"
}

resource "aws_default_vpc" "default" {
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_alinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }
}
#------------

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
    Name  = "Dynamic Security Group"
    Owner = "Andrei Belyi"
  }
}

#---

resource "aws_launch_configuration" "web" {
  name_prefix     = "WebServer-HA-"
  image_id        = data.aws_ami.latest_alinux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#---

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id] #!!!
  load_balancers       = [aws_elb.web.name]                                                     #!!!


  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "Andrei Belyi"
      TAGKEY = "TAGVALUE"
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

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
