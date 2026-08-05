output "s3_bucket_name" {
  value       = aws_s3_bucket.telemetry.bucket
  description = "Nome do bucket de telemetria criado"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.telemetry.arn
  description = "ARN do bucket criado"
}
output "sqs_queue_url" {
  value       = aws_sqs_queue.telemetry_queue.id
  description = "URL da fila SQS de telemetria"
}