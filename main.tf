#-------------------------
# terraform configuration
#-------------------------
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    # GitHubをTerraformで管理したい時だけ使う
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
#--------------------------
# provider
#--------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

provider "github" {
  owner = "GitHub Organization"
}

#--------------------------
# Variables
#--------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
}