
module "vpc" {
  source = "./modules/localstack/vpc"
}

resource "aws_instance" "my_instance" {
  name = "instance_name"
  ami  = aws_ami.test.id
}

data "random_password" "mypassword" {}

resource "aws_ami" "test" {
  name = "my_ami"
}
