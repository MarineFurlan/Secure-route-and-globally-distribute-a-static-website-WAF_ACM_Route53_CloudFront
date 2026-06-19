variable "waf_name" {
  type    = string
  default = "prod-web-acl"
}

variable "domain" {
  type    = string
}

variable "bucket_name" {
  type    = string
  default = "secure-static-website-001"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
