variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Região padrão para os recursos AWS"
}

variable "bucket_name" {
  type        = string
  default     = "cloudstatus-telemetry-data"
  description = "Nome do bucket S3 de telemetria"
}