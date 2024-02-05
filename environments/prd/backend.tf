terraform {
    required_version = ">=0.13"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
      }
    }

    # backend = local
    backend "local" {
      
    }

    # backend = "s3"
    # backend "s3" {
    #     bucket = "terraform-backend"
    #     key = "terraform.tfstate"
    #     region = "ap-northeast-1"
    #     acl = "bucket-owner-full-control"
    # }
}