provider "aws" {
  region = var.region

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
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.latest_alinux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  monitoring             = var.detailed_monitoring
}
#-----------------
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.server.id
  #tags     = var.common-tags
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} Server IP" })
}

resource "aws_default_vpc" "default" {}

#------------------
resource "aws_security_group" "web" {
  name        = "Dynamic SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.inbound_ports
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
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} Web Security Group" })

}
#------------------

#------------------

#------------------


#------------------
