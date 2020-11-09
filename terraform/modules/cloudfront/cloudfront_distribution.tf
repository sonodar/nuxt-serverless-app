resource "aws_cloudfront_distribution" "distribution" {
  enabled         = true
  is_ipv6_enabled = var.is_ipv6_enabled
  comment         = local.comment
  tags            = merge(var.base_tags, map("Name", var.domain_name))
  price_class     = "PriceClass_200"
  aliases         = [var.domain_name]

  # API Gateway Lambda Proxy のオリジン設定
  origin {
    domain_name = local.api_domain_name
    origin_id   = local.api_origin_id
    origin_path = "/${var.rest_api_deployment_stage_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # 画像ファイルなどが格納されている S3 のオリジン設定
  origin {
    domain_name = var.assets_bucket_regional_domain_name
    origin_id   = var.assets_bucket_name
    origin_path = local.s3_origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  # API は API Gateway Lambda Proxy へ
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.api_origin_id

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    dynamic lambda_function_association {
      for_each = local.api_lambda_associations
      content {
        event_type   = lambda_function_association.value.event_type
        include_body = lambda_function_association.value.include_body
        lambda_arn   = lambda_function_association.value.lambda_arn
      }
    }
  }

  # 画像などの assets は S3 へ
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.assets_bucket_name

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    dynamic lambda_function_association {
      for_each = local.assets_lambda_associations
      content {
        event_type   = lambda_function_association.value.event_type
        include_body = lambda_function_association.value.include_body
        lambda_arn   = lambda_function_association.value.lambda_arn
      }
    }
  }

  # 上記以外のアクセスは Nuxt へ (API と同じだが、メソッドが異なる)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.api_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    dynamic lambda_function_association {
      for_each = local.app_lambda_associations
      content {
        event_type   = lambda_function_association.value.event_type
        include_body = lambda_function_association.value.include_body
        lambda_arn   = lambda_function_association.value.lambda_arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  # ログバケットが指定されていた場合のみ有効化
  dynamic logging_config {
    for_each = local.logging_config
    content {
      include_cookies = false
      bucket          = "${logging_config.value.bucket}.s3.amazonaws.com"
      prefix          = logging_config.value.prefix
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = local.comment
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.assets_bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
