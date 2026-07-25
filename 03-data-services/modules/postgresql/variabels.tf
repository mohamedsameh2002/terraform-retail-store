variable "private_subnet_ids" {
  type        = list(string)
  default     = null
}



variable "username" {
  type = string
  default = null
}

variable "password" {
  type = string
  default = null
}

variable "vpc_id" {
  type = string
  default = null
}

variable "eks_security_group_id" {
  type = string
  default = null
}


variable "environment_name" {
  type        = string
  default     = null
}
