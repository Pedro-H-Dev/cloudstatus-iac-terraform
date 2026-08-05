resource "aws_s3_bucket" "telemetry" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_sqs_queue" "telemetry_queue" {
  name                      = "cloudstatus-telemetry-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
}

resource "aws_sqs_queue_policy" "telemetry_policy" {
  queue_url = aws_sqs_queue.telemetry_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.telemetry_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.telemetry.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.telemetry.id

  queue {
    queue_arn = aws_sqs_queue.telemetry_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/index.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_sqs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "telemetry_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "cloudstatus-telemetry-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "python3.10"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.telemetry_queue.arn
  function_name    = aws_lambda_function.telemetry_processor.arn
  batch_size       = 1
}