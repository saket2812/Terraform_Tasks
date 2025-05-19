# resource "aws_ecs_cluster" "main" {
#   name = "${var.app_name}-cluster"
# }

# resource "aws_ecs_task_definition" "flask_backend" {
#   family                   = "${var.app_name}-flask-backend"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
#   container_definitions = jsonencode([{
#     name      = "flask-backend"
#     image     = "${aws_ecr_repository.flask_backend.repository_url}:latest"
#     essential = true
#     portMappings = [{
#       protocol      = "tcp"
#       containerPort = var.flask_port
#       hostPort      = var.flask_port
#     }]
#   }])
# }

# resource "aws_ecs_service" "flask_backend" {
#   name            = "${var.app_name}-flask-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.flask_backend.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups = [aws_security_group.ecs_tasks.id]
#     subnets         = aws_subnet.public[*].id
#     assign_public_ip = true
#   }
# }
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "flask",
    image     = "934573416271.dkr.ecr.ap-south-1.amazonaws.com/flask-backend:latest",
    essential = true,
    portMappings = [{
      protocol      = "tcp",
      containerPort = 5000,
      hostPort      = 5000
    }]
  }])
}

resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_tg.arn
    container_name   = "flask"
    container_port   = 5000
  }
}
resource "aws_ecs_task_definition" "express_task" {
  family                   = "express-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "express",
    image     = "934573416271.dkr.ecr.ap-south-1.amazonaws.com/express-frontend:latest",
    essential = true,
    portMappings = [{
      protocol      = "tcp",
      containerPort = 3000,
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "express_service" {
  name            = "express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.express_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_tg.arn
    container_name   = "express"
    container_port   = 3000
  }
}
