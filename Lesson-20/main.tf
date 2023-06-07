# Provision Resources in Multiply AWS Regions / Accounts


provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::490232787464:role/service-role/aws-codestar-service-role"
    session_name = "try-1"
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "USA"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "GER"
}

# =======================

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.GER
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }
}

resource "aws_instance" "default_server" {
  instance_type = "t2.micro"
  ami           = "ami-0715c1897453cabd1"
  tags = {
    Name = "Default Server"
  }
}


resource "aws_instance" "US-server-2" {
  provider      = aws.USA
  instance_type = "t2.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  tags = {
    Name = "Default USA Server"
  }
}

resource "aws_instance" "my_ger_server" {
  provider      = aws.GER
  instance_type = "t2.micro"
  ami           = data.aws_ami.ger_latest_ubuntu.id
  tags = {
    Name = "GERMANY Server"
  }
}
