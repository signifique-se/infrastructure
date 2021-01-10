terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

provider "aws" {
  alias   = "useast1"
  profile = "default"
  region  = "us-east-1"
}
