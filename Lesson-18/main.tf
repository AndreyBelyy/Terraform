provider "aws" {
  region = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "Andrei"
}

variable "no_prod_owner" {
  default = "Inokentiy"
}


variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t2.small"
  }
}

variable "allow_ports" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "my_webserver1" {
  ami = "ami-0715c1897453cabd1"
  //instance_type = (var.env == "prod" ? "t2.large" : "t2.micro")
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.no_prod_owner
  }
}



resource "aws_instance" "my_webserver2_for_dev" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-0715c1897453cabd1"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server-s"
    Owner = var.env == "prod" ? var.prod_owner : var.no_prod_owner
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = lookup(var.allow_ports, var.env)
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
    Name = "80 port"
  }
}
