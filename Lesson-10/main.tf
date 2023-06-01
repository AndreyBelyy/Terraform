#---
# Terraform
#
# Find Latest AMI id of:
#
#   - Ubuntu 18.04
#   - Amazon Linux 2
#   - Windows Server
#
# Lesson by Denis Astahov, student Andrei Belyi
#---

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

data "aws_ami" "latest_alinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }
}

output "latest_alinux_ami_id" {
  value = data.aws_ami.latest_alinux.id
}
output "latest_alinux_ami_name" {
  value = data.aws_ami.latest_alinux.name
}


data "aws_ami" "latest_windows_server" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

output "latest_wserver_ami_id" {
  value = data.aws_ami.latest_windows_server.id
}
output "latest_wserver_ami_name" {
  value = data.aws_ami.latest_windows_server.name
}


resource "aws_instance" "my_AL" {
  ami           = data.aws_ami.latest_alinux.id
  instance_type = "t2.micro"
}
