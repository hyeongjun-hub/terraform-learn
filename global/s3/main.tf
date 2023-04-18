provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state-hyeongjun"

  # 중요한 리소스를 실수로 destroy 하지 않게 destroy 중 오류 발생
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  hash_key = "LockID"
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-hyeongjun"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}