provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-hyeongjun"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  max_size = 2
  min_size = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}