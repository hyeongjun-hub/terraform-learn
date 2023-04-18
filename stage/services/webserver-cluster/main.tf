provider "aws" {
  region = "ap-northeast-2"
}

//resource "aws_instance" "example" {
//  ami = "ami-04cebc8d6c4f297a3"
//  instance_type = "t2.micro"
//  vpc_security_group_ids = [aws_security_group.instance.id]
//
//  user_data = <<-EOF
//#!/bin/bash
//echo 'Hello, world~~!' >> index.html
//nohup busybox httpd -f -p ${var.server_port} &
//                EOF
//
//  tags = {
//    Name = "terraform-example"
//  }
//}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-04cebc8d6c4f297a3"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = data.template_file.user_data.rendered

//  user_data = <<-EOF
//#!/bin/bash
//echo 'Hello, world~~!' >> index.html
//echo "${data.terraform_remote_state.db.outputs.address}" >> index.html
//echo "${data.terraform_remote_state.db.outputs.port}" >> index.html
//nohup busybox httpd -f -p ${var.server_port} &
//                EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
//  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  availability_zones   = ["ap-northeast-2a", "ap-northeast-2c"]

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"


  min_size = 2
  max_size = 4


  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_alb" "example" {
  name = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.example.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found :<"
      status_code = "404"
    }
  }
}

// 대상 그룹 설정
resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-up-and-running-state-hyeongjun"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
  }
}