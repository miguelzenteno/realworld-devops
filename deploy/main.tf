resource "aws_cloudfront_distribution" "frontend" {
  depends_on          = [aws_s3_bucket.frontend]
  is_ipv6_enabled     = true
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  wait_for_deployment = true
  web_acl_id          = aws_wafv2_web_acl.cloudfront_waf_acl.arn
  ordered_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/dev/*"
    target_origin_id       = "${data.aws_api_gateway_rest_api.backend.id}.execute-api.us-east-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string            = true
      cookies {
        forward           = "none"
      }
    }
  }
  origin {
    origin_id   = "${data.aws_api_gateway_rest_api.backend.id}.execute-api.us-east-1.amazonaws.com"
    domain_name = "${data.aws_api_gateway_rest_api.backend.id}.execute-api.us-east-1.amazonaws.com"
    custom_header {
      name  = var.authKey
      value = var.authValue
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  origin {
    origin_id   = "miguel-poc-serverless-frontend-${var.environment}.s3.us-west-2.amazonaws.com"
    domain_name = "miguel-poc-serverless-frontend-${var.environment}.s3.us-west-2.amazonaws.com"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.CachingDisabled.id
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    target_origin_id       = "miguel-poc-serverless-frontend-${var.environment}.s3.us-west-2.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0
    min_ttl                = 0
    max_ttl                = 0
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  logging_config {
    bucket = module.log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }
}