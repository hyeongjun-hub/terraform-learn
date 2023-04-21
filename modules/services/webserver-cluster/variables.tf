variable "server_port" {
  description = "HTTP 요청에 사용할 Port번호 지정"
  type = number
  default = 8080
}

variable "cluster_name" {
  type = string
}

variable "db_remote_state_bucket" {
  type = string
}

variable "db_remote_state_key" {
  type = string
}

variable "instance_type" {
  type = string
  description = "EC2 인스턴스 타입"
}

variable "min_size" {
  type = number
  description = "EC2 인스턴스의 최소 수"
}

variable "max_size" {
  type = number
}