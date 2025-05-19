terraform {
  backend "s3" {
    bucket         = "terratute"
    key            = "flask-express-ecs/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}