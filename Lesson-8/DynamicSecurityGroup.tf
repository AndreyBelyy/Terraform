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

resource "aws_instance" "my_webserver1" {
  ami                    = "ami-0715c1897453cabd1" # AL AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web server build on Terraform"
  }
  depends_on = [aws_instance.my_webserver3, aws_instance.my_webserver2]
}

resource "aws_instance" "my_webserver2" {
  ami                    = "ami-0715c1897453cabd1" # AL AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web server application"
  }
  depends_on = [aws_instance.my_webserver3]
}

resource "aws_instance" "my_webserver3" {
  ami                    = "ami-0715c1897453cabd1" # AL AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web server database"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "MSG"
  description = "Allow inbound traffic"

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
    Name = "80 port"
  }
}
