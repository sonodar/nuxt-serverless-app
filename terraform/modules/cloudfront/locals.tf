locals {
  comment         = coalesce(var.comment, var.domain_name)
  api_origin_id   = "nuxt-api-gateway"
  api_domain_name = "${var.rest_api_id}.execute-api.${var.rest_api_region}.amazonaws.com"
  s3_origin_path  = var.assets_bucket_prefix != "" ? "/${var.assets_bucket_prefix}" : ""
  # ログバケットが指定されていた場合のみ有効化
  logging_config = var.log_bucket_name != "" ? [{
    bucket = var.log_bucket_name
    prefix = var.log_bucket_prefix
  }] : []
  # 各ビヘイビアに対してアタッチする Lambda@Edge 関数
  assets_lambda_associations = length(var.assets_lambda_associations) == 0 ? var.default_lambda_associations : var.assets_lambda_associations
  api_lambda_associations    = length(var.api_lambda_associations) == 0 ? var.default_lambda_associations : var.api_lambda_associations
  app_lambda_associations    = length(var.app_lambda_associations) == 0 ? var.default_lambda_associations : var.app_lambda_associations
}
