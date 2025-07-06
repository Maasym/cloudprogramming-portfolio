resource "aws_cloudfront_origin_access_control" "default" {
  provider                          = aws.us_east_1
  name                              = "oac-for-greenleaf-web"
  description                       = "Origin Access Control for the Greenleaf website S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  provider= aws.us_east_1  
  enabled = true 

  origin {
    domain_name              = aws_s3_bucket.web_hosting.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.web_hosting.id}"
    
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id

    origin_path = "/dist"
  }

  default_root_object = "index.html"

  web_acl_id = aws_wafv2_web_acl.default.arn

  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.web_hosting.id}"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags
}