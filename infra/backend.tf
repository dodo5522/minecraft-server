terraform {
  required_version = "~> 1.9.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.6.0"
    }
  }

  backend "s3" {
    key    = "terraform/minecraft-server.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
