# output "alb_dns_name" {
#   value = aws_lb.main.dns_name
#   description = "The DNS name of the ALB"
# }
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
