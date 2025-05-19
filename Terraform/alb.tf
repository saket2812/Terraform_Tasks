# resource "aws_lb" "main" {
#   name               = "${var.app_name}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = aws_subnet.public[*].id

#   tags = {
#     Environment = var.environment
#   }
# }

# resource "aws_lb_target_group" "flask" {
#   name        = "${var.app_name}-flask-tg"
#   port        = var.flask_port
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     path                = "/health"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     matcher             = "200-299"
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.flask.arn
#   }
# }
resource "aws_lb" "app_alb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_lb_target_group" "flask_tg" {
  name        = "flask-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/api"  # Changed to match actual endpoint
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group" "express_tg" {
  name        = "express-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.express_tg.arn
  }
}

# Main API route
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api*"]  # Changed to catch all /api routes
    }
  }
}

# CORS OPTIONS route
resource "aws_lb_listener_rule" "api_options" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10  # Higher priority than main API rule

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }

  condition {
    http_request_method {
      values = ["OPTIONS"]
    }
  }
}

# Submit route
resource "aws_lb_listener_rule" "submit" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }

  condition {
    path_pattern {
      values = ["/submit*"]
    }
  }
}