provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "arfa" {
    ami             = "ami-053b0d53c279acc90"
    instance_type   = "t2.micro"
    tags = {
        Name = "jandt"
    }
}

terrafrom {
    backend "s3" {
        bucket = "devopsprojectaw"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
