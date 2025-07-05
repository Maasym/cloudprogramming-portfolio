resource "aws_s3_bucket" "web_hosting" {
  bucket = "greenleaf-web-${var.environment}"
  tags   = var.tags
}

resource "aws_s3_bucket_ownership_controls" "web_hosting" {
  bucket = aws_s3_bucket.web_hosting.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "web_hosting" {
  bucket                  = aws_s3_bucket.web_hosting.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}