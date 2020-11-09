variable base_tags { type = map }
variable domain_name {}
variable comment { default = "" }
variable assets_bucket_name {}
variable assets_bucket_regional_domain_name {}
variable assets_bucket_prefix { default = "" }
variable is_ipv6_enabled { type = bool }
variable rest_api_id {}
variable rest_api_region {}
variable rest_api_deployment_stage_name {}
variable log_bucket_name { default = "" }
variable log_bucket_prefix { default = "" }
variable acm_certificate_arn {}
variable hosted_zone_id {}

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
