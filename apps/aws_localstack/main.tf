module "vpc" {
  source = "../../modules/localstack/vpc"
}

resource "aws_instance" "my_instance" {
  instance_type = "t2.micro"
  subnet_id     = module.vpc.subnet_id
  ami           = aws_ami.test.id
  key_name      = "my_key"
}

resource "aws_ami" "test" {
  name = "my_ami"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-bucket"
}
