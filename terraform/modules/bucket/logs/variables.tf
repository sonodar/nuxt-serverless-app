variable bucket_name {}
variable bucket_tags { type = map }
variable lifecycle_enabled { default = true }
variable transition_onezone_days { default = 30 }
variable transition_glacier_days { default = 90 }
variable expiration_days { default = 180 }
