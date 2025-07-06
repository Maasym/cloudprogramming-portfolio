# S3 bucket for hosting static website
resource "aws_s3_bucket" "web_hosting" {
  bucket = "greenleaf-web-${var.environment}"
  tags   = var.tags
}

# Enforce bucket ownership for all uploaded objects
resource "aws_s3_bucket_ownership_controls" "web_hosting" {
  bucket = aws_s3_bucket.web_hosting.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block public ACLs while allowing public access via CloudFront
resource "aws_s3_bucket_public_access_block" "web_hosting" {
  bucket                  = aws_s3_bucket.web_hosting.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# S3 bucket policy to allow CloudFront access to objects in the bucket
resource "aws_s3_bucket_policy" "web_hosting_policy" {
  bucket = aws_s3_bucket.web_hosting.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.web_hosting.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}