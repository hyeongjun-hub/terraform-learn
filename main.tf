provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami = "ami-04cebc8d6c4f297a3"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
