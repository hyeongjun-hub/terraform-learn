output "address" {
  value = aws_db_instance.example.address
  description = "database endpoint"
}

output "port" {
  value = aws_db_instance.example.port
  description = "database listening port number"
}