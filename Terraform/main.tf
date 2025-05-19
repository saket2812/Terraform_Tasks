# provider "aws" {
#   region = var.aws_region
# }

# terraform {
#   required_version = ">= 1.0.0"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }
# Create VPC
# resource "aws_vpc" "main" {
#   cidr_block = var.vpc_cidr_block
# }

# Create ECS Cluster
