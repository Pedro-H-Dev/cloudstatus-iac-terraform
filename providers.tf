terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3     = "http://127.0.0.1:4566"
    sqs    = "http://127.0.0.1:4566"
    lambda = "http://127.0.0.1:4566"
    iam    = "http://127.0.0.1:4566"
    sts    = "http://127.0.0.1:4566"
  }
}