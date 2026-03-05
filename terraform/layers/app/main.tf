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

resource "aws_ecs_service" "frontend" {
  name            = "${var.name}-frontend"
  cluster         = data.terraform_remote_state.ops.outputs.cluster_name
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    # If there is no ALB, the Fargate task may need to be in a public subnet with a public IP 
    # so you can reach it over the internet.
    subnets          = data.terraform_remote_state.bootstrap.outputs.public_subnets
    security_groups  = [data.terraform_remote_state.ops.outputs.ecs_tasks_security_group_id]
    assign_public_ip = true
  }
}
