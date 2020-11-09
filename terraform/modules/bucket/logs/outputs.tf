output "log_bucket" {
  value = {
    name = aws_s3_bucket.logs.id
    arn  = aws_s3_bucket.logs.arn
  }
}
