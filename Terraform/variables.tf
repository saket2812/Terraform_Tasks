# variable "aws_region" {
#   description = "AWS region to deploy resources"
#   default     = "ap-south-1"
# }

# variable "instance_type" {
#   description = "EC2 instance type"
#   default     = "t2.micro"
# }

# variable "key_name" {
#   description = "Name of the SSH key pair to use"
#   default     = "tutedude-aws-key"
# }

# variable "flask_port" {
#   description = "Port for Flask backend"
#   default     = 5000
# }

# variable "express_port" {
#   description = "Port for Express frontend"
#   default     = 3000
# }
variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS"
  default     = "ami-0e35ddab05955cf57"
}
