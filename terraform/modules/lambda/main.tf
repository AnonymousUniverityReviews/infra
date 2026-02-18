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

data "archive_file" "function" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/function.zip"
}
resource "aws_lambda_function" "function" {
  filename      = data.archive_file.function.output_path
  function_name = var.name
  role          = aws_iam_role.role.arn
  handler       = var.handler
  code_sha256   = data.archive_file.function.output_base64sha256
  runtime       = var.runtime
}
