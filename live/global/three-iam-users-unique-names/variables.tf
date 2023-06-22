variable "user_names" {
  description = "Create IAM users with these names"
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}

//output "all_arns" {
//  value = values(aws_iam_user.example)[*].arn
//  description = "모든 유저의 ARNs"
//}
//
//output "neo_arns" {
//  value = aws_iam_user.example[0].arn
//  description = "Neo의 ARN"
//}
//
//output "upper_names" {
//  value = { for name in var.user_names : upper(name) => name }
//}
//
//variable "hero_thousand_faces" {
//  description = "map 입니다"
//  type = map(string)
//  default = {
//    neo = "hero"
//    trinity = "love interest"
//    morpheus = "mentor"
//  }
//}
//
//output "bios" {
//  value = {for name, role in var.hero_thousand_faces : "${name} is the ${role}" => upper(role)}
//}

variable "names" {
  description = "렌더링할 이름들"
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}

output "for_directive_strip_marker" {
  value = <<EOF
%{~ for name in var.names}
  ${name}
%{~ endfor }
EOF
}

variable "name" {
  description = "A name to render"
  type = string
}

output "if_else_directive" {
  value = "Hello, %{if var.name != "" }${var.name}%{else}(unnamed)%{endif}"
}