# -----
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Andrei Belyi
# -----

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-0715c1897453cabd1" # AL AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user-data.sh.tpl", {
    f_name = "Andrei",
    l_name = "Belyi",
    names  = ["Vasya", "Kolya", "Juan", "Donald", "Masha"]
  })

  tags = {
    Name = "Web server build on Terraform"
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer"
  description = "Allow inbound traffic"

  ingress {
    description = "80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

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
