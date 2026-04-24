output "s3_bucket_name" { value = module.website.bucket_id }
output "cloudfront_aliases" { value = module.distribution.aliases}
output "cloudfront_id" { value = module.distribution.cloudfront_id}
output "oac_id" { value = module.distribution.origin_access_control_id}
output "website_domain" { value = module.distribution.website_domain}
output "bucket_region" { value = module.website.bucket_region}