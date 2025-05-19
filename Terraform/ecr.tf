# resource "aws_ecr_repository" "flask_backend" {
#   name                 = "${var.app_name}-flask-backend"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

# resource "aws_ecr_repository" "express_frontend" {
#   name                 = "${var.app_name}-express-frontend"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }
resource "aws_ecr_repository" "flask_backend" {
  name = "flask-backend"
}

resource "aws_ecr_repository" "express_frontend" {
  name = "express-frontend"
}

