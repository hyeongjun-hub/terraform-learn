
output "alb_dns_name" {
  description = "web server에 접속하기 위한 public alb dns"
  value = aws_alb.example.dns_name
}