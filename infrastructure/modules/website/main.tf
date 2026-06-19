### === S3 BUCKET === ###
// Stocke les fichiers du site statique
resource "aws_s3_bucket" "site" {
  bucket        = var.bucket_name
  force_destroy = false // Avoids accidental file deletes
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  index_document { suffix = "index.html" }
}

### === ENABLE VERSIONING === ###
resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

### === BLOCK PUBLIC ACCESS === ###
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


### === BLOCK PUBLIC ACCESS WRITES === ###
resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

### === UPLOAD FILES === ###
locals { website_files = fileset("${path.module}/../../../website_files", "**") }

resource "aws_s3_object" "website_files" {
  for_each = {for f in local.website_files : f => f}
  bucket   = aws_s3_bucket.site.id
  key      = each.key
  source   = "${path.module}/../../../website_files/${each.value}"

  content_type = lookup({
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
  }, lower(element(split(".", each.key), length(split(".", each.key)) - 1)), "application/octet-stream")
}

### === RESTRICT ACCESS TO CLOUDFRONT ONLY === ###
data "aws_iam_policy_document" "allow_cloudfront_oac" {
  statement {
    sid     = "AllowCloudFrontServicePrincipal"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    // Only requests signes by CloudFront's OAC are allowed
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}


resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.allow_cloudfront_oac.json
}