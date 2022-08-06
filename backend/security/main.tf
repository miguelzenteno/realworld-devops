resource "aws_wafv2_web_acl" "security" {
  name        = "apigw-security"
  description = "Api Gateway Security"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "custom-header"
    priority = 0

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "EXACTLY"
        search_string         = var.authValue
        field_to_match {
          single_header {
            name = var.authKey
          }
        }
        text_transformation {
          type     = "NONE"
          priority = 0
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "customheader"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "apigwsecurity"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "security" {
  resource_arn = "${data.aws_api_gateway_rest_api.backend.arn}/stages/${var.environment}"
  web_acl_arn  = aws_wafv2_web_acl.security.arn
}