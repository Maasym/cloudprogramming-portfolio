# WAFv2 ACL (Web Application Firewall) to protect CloudFront
resource "aws_wafv2_web_acl" "default" {
  provider    = aws.us_east_1
  name        = "greenleaf-website-acl-${var.environment}"
  description = "WAF for GreenLeaf static website"
  scope       = "CLOUDFRONT"  # Important: WAF for CloudFront is always scoped globally

  # Default action if no rules match
  default_action {
    allow {}
  }

  # Rule 1: Use AWS-managed common rules (e.g., SQLi, XSS, etc.)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {} 
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = false
    }
  }

  # Rule 2: Rate limiting – block IPs with more than 500 requests in 5 minutes
  rule {
    name     = "Rate-Limit-Rule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"

        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "X-Forwarded-For"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  # Rule 3: Block traffic from high-risk regions
  rule {
    name     = "GeoBlockHighRiskRegions"
    priority = 3

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["RU", "CN", "KP", "IR"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoBlockRule"
      sampled_requests_enabled   = true
    }
  }

  # Overall visibility configuration for the WAF
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "GreenLeafWAF"
    sampled_requests_enabled   = false
  }

  tags = var.tags
}