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


#------------------


#------------------

