output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "load balancer의 도메인 name"
}