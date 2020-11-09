output "distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "assets_bucket_policy" {
  value = data.aws_iam_policy_document.s3_policy.json
}
