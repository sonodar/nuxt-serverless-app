output "assets_bucket_arn" {
  value = module.assets_bucket.assets_bucket.arn
}

output "cloudfront_distribution_id" {
  value = module.site_distribution.distribution_id
}
