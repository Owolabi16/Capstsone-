provider "aws" {
  region  = "eu-west-2"
  profile = var.ec2_profile
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}