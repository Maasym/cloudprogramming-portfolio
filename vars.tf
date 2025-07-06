# AWS region for standard resources
variable "aws_region" {
  type        = string
  default     = "eu-central-1"
}

# Used to parameterize the environment
variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}

# Standard tags for consistent resource tagging
variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)
  default = {
    Project     = "GreenLeaf-Web"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}