variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"    
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# variable "app_name" {
  # description = "Application name"
  # default     = "flask-express-app"
# }

# variable "environment" {
  # description = "Deployment environment"
  # default     = "prod"
# }

# variable "flask_port" {
  # description = "Flask backend port"
  # default     = 5000
# }

# variable "express_port" {
  # description = "Express frontend port"
  # default     = 3000
# }