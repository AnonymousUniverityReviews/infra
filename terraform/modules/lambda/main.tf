data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "example" {
  function_name = var.name
  role          = aws_iam_role.role.arn
  package_type  = "Image"
  image_uri     = "585517712585.dkr.ecr.eu-central-1.amazonaws.com/dbmigrations:latest"

#   image_config {
#     command = ["main.handler"]
#   }

  memory_size = 512
  timeout     = 30

  architectures = ["x86_64"]
}
