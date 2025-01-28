# provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "ap-northeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

# LocalStack 測試環境的 AWS 服務端點
  endpoints {
    ec2 = "http://localhost:4566"
    eks = "http://localhost:4566"
    rds = "http://localhost:4566"
    s3  = "http://localhost:4566"      
    redshift = "http://localhost:4566"      
  }

  # LocalStack 測試環境的 AWS 金鑰
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
}