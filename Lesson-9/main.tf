provider "aws" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_availability_zone" "example" {
  name = "us-east-1b"
}

data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}


resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "172.31.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_region.current.name}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.name
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "172.31.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zone.example.name}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.name
  }
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}


output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region" {
  value = data.aws_region.current.description
}

output "data_aws_region_des" {
  value = data.aws_region.current.name
}
