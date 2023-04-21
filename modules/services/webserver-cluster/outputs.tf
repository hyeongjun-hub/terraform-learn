output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "web server에 접속하기 위한 public alb dns"
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "asg의 이름"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "loadbalancer와 attach된 sg의 id"
}