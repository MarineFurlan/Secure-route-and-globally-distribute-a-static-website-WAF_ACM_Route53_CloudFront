output "cloudfront_arn" { value = aws_cloudfront_distribution.cdn.arn }
output "cloudfront_domain_name" { value = aws_cloudfront_distribution.cdn.domain_name }
output "hosted_zone_id" { value = aws_cloudfront_distribution.cdn.hosted_zone_id }
output "origin_access_control_id" { value = aws_cloudfront_origin_access_control.oac.id }
output "aliases" { value = aws_cloudfront_distribution.cdn.aliases }
output "cloudfront_id" { value = aws_cloudfront_distribution.cdn.id}