data "template_file" "bucket_policy" {
  template = file("website_bucket_policy.json")
  vars = {
    bucket         = aws_s3_bucket.frontend.id
    cloudfront_arn = aws_cloudfront_origin_access_identity.frontend.iam_arn
  }
}

data "aws_cloudfront_cache_policy" "CachingDisabled" {
  id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}

data "aws_api_gateway_rest_api" "backend" {
  name     = "${var.environment}-realworld"
  provider = aws.cloudfront
}

data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "current" {}