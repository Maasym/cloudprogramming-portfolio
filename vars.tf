variable "aws_region" {
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)
  default = {
    Project     = "GreenLeaf-Web"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}