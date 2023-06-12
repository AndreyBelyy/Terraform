provider "aws" {
  region = "us-east-1" // Region where to Create Resources
}

terraform {
  backend "s3" {
    bucket = "terrafrom-hub"                  // Bucket where to SAVE Terraform State
    key    = "prod-changes/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                      // Region where bucket is created
  }
}
