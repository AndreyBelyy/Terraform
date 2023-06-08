provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terrafrom-hub"
    key    = "dev/servers/terraform.tfstate"
    region = "us-east-1"
  }
}

#=============

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terrafrom-hub"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "latest_alinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }
}
#==============

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_alinux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnets_ids[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with Remote State"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "WServer"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  description = "Allow inbound traffic"

  ingress {
    description = "80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "22 port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name  = "web-server-sg"
    Owner = "Andrei Belyi"
  }
}

output "network_details" {
  value = data.terraform_remote_state.network
}

output "webserver_sg_id" {
  value = aws_security_group.my_webserver.id

}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
