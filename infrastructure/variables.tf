variable "bucket_name" {
  type    = string
  default = "secure-static-website-001"
}

variable "domain" {
  type    = string
  default = "[your_domain_name]"
}

variable "waf_name" {
  type    = string
  default = "prod-web-acl"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
