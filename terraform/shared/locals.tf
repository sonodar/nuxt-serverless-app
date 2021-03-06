locals {
  # 各ビヘイビアに対してアタッチする Lambda@Edge 関数
  assets_lambda_associations = length(var.assets_lambda_associations) == 0 ? var.default_lambda_associations : var.assets_lambda_associations
  api_lambda_associations    = length(var.api_lambda_associations) == 0 ? var.default_lambda_associations : var.api_lambda_associations
  app_lambda_associations    = length(var.app_lambda_associations) == 0 ? var.default_lambda_associations : var.app_lambda_associations
}
