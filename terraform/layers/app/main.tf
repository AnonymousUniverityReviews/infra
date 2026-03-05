data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.name}-frontend"
  retention_in_days = 7

}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.name}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.terraform_remote_state.ops.outputs.ecs_task_execution_role_arn
  task_role_arn            = data.terraform_remote_state.ops.outputs.ecs_task_role_arn

  container_definitions = jsonencode([{
    name      = "frontend"
    image     = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/frontend:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      { name = "NODE_ENV", value = "production" },
      { name = "NODE_TLS_REJECT_UNAUTHORIZED", value = "0" },
      { name = "NUXT_HOST", value = "0.0.0.0" },
      { name = "NUXT_PORT", value = "80" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.frontend.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])


}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = data.terraform_remote_state.bootstrap.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_lb" "frontend" {
  name               = "${var.name}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.terraform_remote_state.bootstrap.outputs.public_subnets


}

resource "aws_lb_target_group" "frontend" {
  name        = "${var.name}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.bootstrap.outputs.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }


}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_ecs_service" "frontend" {
  name            = "${var.name}-frontend"
  cluster         = data.terraform_remote_state.ops.outputs.cluster_name
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.bootstrap.outputs.private_subnets
    security_groups  = [data.terraform_remote_state.ops.outputs.ecs_tasks_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.frontend]


}
