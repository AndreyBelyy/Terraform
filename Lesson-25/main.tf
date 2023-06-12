# Since Terraform v0.15.2
# terraform apply -replace aws_instance.node2
#
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "node1" {
  ami           = "ami-04a0ae173da5807d3"
  instance_type = "t2.micro"
  tags = {
    Name  = "Node-1"
    Owner = "Andrei Belyi"
  }
}

resource "aws_instance" "node2" {
  ami           = "ami-04a0ae173da5807d3"
  instance_type = "t2.micro"
  tags = {
    Name  = "Node-2"
    Owner = "Andrei Belyi"
  }
}

resource "aws_instance" "node3" {
  ami           = "ami-04a0ae173da5807d3"
  instance_type = "t2.micro"
  tags = {
    Name  = "Node-3"
    Owner = "Andrei Belyi"
  }
  depends_on = [aws_instance.node2]
}
