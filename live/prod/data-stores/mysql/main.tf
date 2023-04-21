provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_db_instance" "example" {
  instance_class = "db.t2.micro"
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  # 10GB storage 할당
  allocated_storage = 10
  name = "example_database_prod"
  username = "admin"

  # password?
  password = var.db_password

  skip_final_snapshot = true
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-hyeongjun"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}