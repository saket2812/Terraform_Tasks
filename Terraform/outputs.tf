output "flask_backend_ip" {
  value = aws_instance.flask_backend.public_ip
}

output "express_frontend_ip" {
  value = aws_instance.express_frontend.public_ip
}