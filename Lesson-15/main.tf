# -------
# Terraform
#
# Local Variables
#
# Made by Andrei Belyi
# -------

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
}
locals {
  country  = "Canada"
  city     = "Deadmonton"
  place    = "${local.country}-${local.city}"
  region   = data.aws_region.current.description
  az_list  = join(";", data.aws_availability_zones.available.names)
  location = "In ${local.region} are ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name       = "Static IP"
    Owner      = var.owner
    Project    = local.full_project_name
    proj_owner = local.project_owner
    place      = local.place
    reg_azs    = local.az_list
    location   = local.location
  }
}
