resource "aws_wafv2_ip_set" "ip_whitelist" {
  name               = "cloudfront_match_ip_whitelist"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.ip_whitelist
  provider           = aws.cloudfront
}

resource "aws_wafv2_web_acl" "cloudfront_waf_acl" {
  name     = "cloudfront_waf_acl"
  scope    = "CLOUDFRONT"
  provider = aws.cloudfront

  default_action {
    block {}
  }

  rule {
    name     = "cloudfront_ip_whitelist_rule"
    priority = 0
    
    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_whitelist.arn
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cloudfront-ip-whitelist"
      sampled_requests_enabled   = true
    }
  }
  
  rule {
    name     = "AWSManagedIpReputation"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "default-WAF-IP-Bad-Rep"
      sampled_requests_enabled   = true
    }
  }

    visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfront-waf-acl"
    sampled_requests_enabled   = true
  }
}