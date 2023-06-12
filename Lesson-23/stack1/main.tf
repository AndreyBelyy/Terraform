# Global variables form Remote State

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "terrafrom-hub"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  zip          = data.terraform_remote_state.global.outputs.zip
  common_tags  = data.terraform_remote_state.global.outputs.tags
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name    = "Stack1-VPC1"
    Company = local.company_name
    Zip     = local.zip
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.2.0.0/16"
  tags       = merge(local.common_tags, { Name = "Stack1-VPC2" })
}
