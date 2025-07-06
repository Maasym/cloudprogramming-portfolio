# Default AWS provider
provider "aws" {
  region = var.aws_region
}

# Secondary provider alias for us-east-1 (required for global services like CloudFront and WAFv2 for CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}