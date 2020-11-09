# アクセスログやアプリケーションログを格納するバケット。
resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  tags   = var.bucket_tags

  lifecycle_rule {
    id      = "all"
    enabled = var.lifecycle_enabled

    transition {
      storage_class = "ONEZONE_IA"
      days          = var.transition_onezone_days
    }

    transition {
      storage_class = "GLACIER"
      days          = var.transition_glacier_days
    }

    expiration {
      days = var.expiration_days
    }
  }

  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  # CloudFrontのログ書き込み（固定）
  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
}

data "aws_canonical_user_id" "current_user" {}
