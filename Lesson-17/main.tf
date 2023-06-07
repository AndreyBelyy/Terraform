# Password generation and using SSM Parameter Store

provider "aws" {
  region = "us-east-2"
}

variable "name" {
  default = "vasya"
}
resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = ":!@$>"
  keepers = {
    keeper1 = var.name
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/sql"
  description = "Main password for RDS"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

resource "aws_db_instance" "default" {
  identifier        = "prod-rds"
  allocated_storage = 10
  db_name           = "mydb"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  #manage_master_user_password   = true
  #master_user_secret_kms_key_id = aws_kms_key.example.key_id
  #name                          = "prod"
  username             = "Oleg"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/sql"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password-1" {
  value     = data.aws_ssm_parameter.my_rds_password.value
  sensitive = true
}

