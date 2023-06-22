provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source = "github.com/hyeongjun-hub/terraform_modules//services/webserver-cluster?ref=v0.0.2"
//  source = "git@github.com:hyeongjun-hub/terraform_modules.git//services/webserver-cluster?ref=v0.0.1"


  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-hyeongjun"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  max_size = 2
  min_size = 2

  enable_autoscaling = false
  enable_new_user_data = true
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}