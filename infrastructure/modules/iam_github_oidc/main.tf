# OIDC Provider GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Role assumable uniquement par repo GitHub spécifique
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:ref:refs/heads/${var.branch}"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# Policy IAM pour déployer sur S3 + invalider CloudFront
data "aws_iam_policy_document" "deploy" {
  statement {
    actions = [
      "s3:PutObject", "s3:PutObjectAcl", "s3:DeleteObject",
      "s3:GetObject", "s3:ListBucket"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
  statement {
    actions = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "deploy_policy" {
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.deploy.json
}
