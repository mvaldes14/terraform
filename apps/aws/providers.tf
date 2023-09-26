terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::375195053376:role/terraform-assume-role"
    session_name = "terraform-aws"
    external_id = "3b49c2d8-e6f0-4ddb-9a89-6c7f67358519"
  }
}
