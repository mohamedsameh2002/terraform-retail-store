
variable "cluster_name" {
  type        = string
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = null
}

variable "aws_region" {
  type        = string
  default     = null
}

variable "account_id" {
  type        = number
  default     = null
}

variable "environment_name" {
  type        = string
  default     = null
}

variable "eks_cluster_endpoint" {
  type        = string
  default     = null
}



