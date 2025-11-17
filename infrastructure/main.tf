terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" # par défaut pour S3, Route53
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}


### === S3 BUCKET === ###
module "website" {
  source = "./modules/website"

  bucket_name                 = var.bucket_name
  cloudfront_distribution_arn = module.distribution.cloudfront_arn
}


### === CLOUDFRONT DISTRIBUTION === ###
module "distribution" {
  source = "./modules/distribution"

  providers = {
    aws = aws.us_east_1
  }

  domain                = var.domain
  s3_bucket_id          = module.website.bucket_id
  s3_bucket_domain_name = module.website.bucket_domain_name
  waf_acl_arn           = module.waf.web_acl_arn
  price_class           = var.price_class

}


### === WEB APPLICATION FIREWALL === ###
module "waf" {
  source = "./modules/waf"

  providers = {
    aws = aws.us_east_1
  }

  name = var.waf_name

}


### === GITHUB ACTIONS === ###
module "github_oidc" {
  source        = "modules/iam_github_oidc"
  role_name     = var.github_role_name
  github_repo   = var.github_repo
  branch        = var.github_branch
  s3_bucket_arn = module.website.bucket_arn
}
