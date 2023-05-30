provider "aws" {

  region = "us-east-1"
}


resource "aws_instance" "my_AL" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Andrei Belyi"
    Project = "Terraform Lessons"
  }
}
resource "aws_instance" "my_Ubuntu" {
  count         = 1
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  tags = {
    Name    = "My Ubuntu Server"
    Owner   = "Andrei Belyi"
    Project = "Terraform Lessons"
  }
}
