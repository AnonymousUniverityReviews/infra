module "iam" {
  source = "../../modules/iam"
  name   = var.name
  tags   = var.tags
}

module "ecs" {
  source       = "../../modules/ecs"
  cluster_name = var.name
}

module "studentus_db" {
  source  = "../../modules/rds"
  name    = "studentus-db"
  subnets = data.terraform_remote_state.bootstrap.outputs.private_subnets
}

module "backend_data_protection_db" {
  source  = "../../modules/rds"
  name    = "backend-data-protection-db"
  subnets = data.terraform_remote_state.bootstrap.outputs.private_subnets
}

# module "migration_lambda" {
#   source      = "../../modules/lambda"
#   name        = "dbmigrations"
#   role_name   = "lambda_dbmigrations_lambda_role"
#   runtime     = "python3.13"
#   handler     = "main.handler"
#   source_file = "../../../lambda/dbmigrations"
# }

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
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

  tags = var.tags
  lifecycle {
    ignore_changes = [name]
  }
}
