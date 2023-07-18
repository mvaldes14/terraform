terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://192.168.1.2:4566"
    ec2 = "http://192.168.1.2:4566"
    rds = "http://192.168.1.2:4566"
    iam = "http://192.168.1.2:4566"
  }
}
