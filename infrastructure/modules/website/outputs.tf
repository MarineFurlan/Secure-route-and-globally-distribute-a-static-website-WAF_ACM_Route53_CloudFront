output "bucket_id" { value = aws_s3_bucket.site.id}
output "bucket_domain_name" { value = aws_s3_bucket.site.bucket_regional_domain_name}
output "bucket_arn" { value = aws_s3_bucket.site.arn }
output "website_files_list" { value = local.website_files }
output "bucket_region" { value = aws_s3_bucket.site.region}