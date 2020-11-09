data "aws_cloudformation_stack" "app_stack" {
  name = var.app_stack_name
}

module certificate {
  source           = "../modules/certificate"
  domain_name      = var.domain_name
  hosted_zone_id   = var.hosted_zone_id
  certificate_tags = var.base_tags

  providers = {
    aws = aws.cloudfront
  }
}

module assets_bucket {
  source      = "../modules/bucket/assets"
  bucket_name = var.assets_bucket_name
  bucket_tags = var.base_tags
}

module log_bucket {
  count                   = var.log_bucket_name != "" ? 1 : 0
  source                  = "../modules/bucket/logs"
  bucket_name             = var.log_bucket_name
  bucket_tags             = var.base_tags
  lifecycle_enabled       = var.log_bucket_lifecycle_enabled
  transition_onezone_days = var.log_bucket_transition_onezone_days
  transition_glacier_days = var.log_bucket_transition_glacier_days
  expiration_days         = var.log_bucket_expiration_days
}

module site_distribution {
  source                         = "../modules/cloudfront"
  domain_name                    = var.domain_name
  base_tags                      = var.base_tags
  comment                        = var.cloudfront_comment
  assets_bucket_name             = module.assets_bucket.assets_bucket.name
  assets_bucket_regional_domain_name = module.assets_bucket.assets_bucket.regional_domain_name
  assets_bucket_prefix           = var.assets_bucket_prefix
  is_ipv6_enabled                = var.is_ipv6_enabled
  rest_api_id                    = data.aws_cloudformation_stack.app_stack.outputs.RestApiId
  rest_api_region                = data.aws_cloudformation_stack.app_stack.outputs.RestApiRegion
  rest_api_deployment_stage_name = data.aws_cloudformation_stack.app_stack.outputs.DeploymentStageName
  log_bucket_name                = var.log_bucket_name
  log_bucket_prefix              = var.log_bucket_prefix
  acm_certificate_arn            = module.certificate.certificate_arn
  hosted_zone_id                 = var.hosted_zone_id
  default_lambda_associations    = var.default_lambda_associations
  assets_lambda_associations     = var.assets_lambda_associations
  api_lambda_associations        = var.api_lambda_associations
  app_lambda_associations        = var.app_lambda_associations

  providers = {
    aws = aws.cloudfront
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = var.assets_bucket_name
  policy = module.site_distribution.assets_bucket_policy
}
