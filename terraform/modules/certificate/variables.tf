variable domain_name {}
variable hosted_zone_id {}
variable certificate_tags { type = map }

variable subject_alternative_names {
  type    = list(string)
  default = []
}
