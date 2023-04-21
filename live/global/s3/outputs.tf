output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "s3 bucket의 ARN(Amazon Resource Name)"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock.name
  description = "DynamoDB 테이블 명"
}