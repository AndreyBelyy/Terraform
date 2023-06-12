provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terrafrom-hub"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}


#======
output "zip" {
  value = "197372"
}

output "company_name" {
  value = "Software comp."
}

output "owner" {
  value = "Andrei"
}

output "tags" {
  value = {
    Project = "Venus"
    ITDep   = "IT"
    Sun     = "Sun"
  }
}
