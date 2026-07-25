# --------------------------------------------------------
# AWS Region (used in provider block)
# --------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# --------------------------------------------------------
# Environment & Business Division Info
# --------------------------------------------------------

# Logical environment name (used in tags and resource names)
variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

# Business unit or department (used in tags and naming)
variable "business_division" {
  description = "Business Division in the large organization this infrastructure belongs to"
  type        = string
  default     = "retail"
}


variable "instance_class" {
  type = string
  default = "db.t3.micro"
}