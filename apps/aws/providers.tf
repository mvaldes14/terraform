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
  }
}
