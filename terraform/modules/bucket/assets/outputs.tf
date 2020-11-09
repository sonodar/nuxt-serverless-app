output "assets_bucket" {
  value = {
    name = aws_s3_bucket.assets.id
    arn  = aws_s3_bucket.assets.arn
    regional_domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
  }
}
