variable aws_region { default = "ap-northeast-1" }
variable base_tags { type = map }
variable app_stack_name {}
variable domain_name {}
variable hosted_zone_id {}
variable assets_bucket_name {}
variable log_bucket_name {}
variable log_bucket_lifecycle_enabled { default = true }
variable log_bucket_transition_onezone_days { default = 60 }
variable log_bucket_transition_glacier_days { default = 180 }
variable log_bucket_expiration_days { default = 365 }

variable cloudfront_comment { default = "" }
variable is_ipv6_enabled { default = true }
variable assets_bucket_prefix { default = "site" }
variable log_bucket_prefix { default = "cf/" }

variable default_lambda_associations {
  type = list(object({
    event_type   = string
    include_body = bool
    lambda_arn   = string
  }))
  default = []
}

variable assets_lambda_associations {
  type = list(object({
    event_type   = string
    include_body = bool
    lambda_arn   = string
  }))
  default = []
}

variable api_lambda_associations {
  type = list(object({
    event_type   = string
    include_body = bool
    lambda_arn   = string
  }))
  default = []
}

variable app_lambda_associations {
  type = list(object({
    event_type   = string
    include_body = bool
    lambda_arn   = string
  }))
  default = []
}
