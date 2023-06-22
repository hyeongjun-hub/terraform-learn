provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name = "webserver-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-hyeongjun"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro" # prod 환경이니깐 더 큰 걸로 할까?
  min_size = 2
  max_size = 2

  custom_tags = {
    Owner = "team-foo"
    DeployedBy = "terraform"
  }

  enable_autoscaling = true
  enable_new_user_data = false
}

//
//resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
//  scheduled_action_name = "-scale-out-during-business-hours"
//  min_size = 2
//  max_size = 10
//  desired_capacity = 10
//  recurrence = "0 9 * * *"
//  autoscaling_group_name = module.webserver_cluster.asg_name
//}
//
//resource "aws_autoscaling_schedule" "scale_in_at_night" {
//  scheduled_action_name = "scale-in-at-night"
//  min_size = 2
//  max_size = 10
//  desired_capacity = 2
//  recurrence = "0 17 * * *"
//  autoscaling_group_name = module.webserver_cluster.asg_name
//}