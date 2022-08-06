variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "authKey" {
  description = "Header auth key"
  type        = string
  default     = "auth-header"
}

variable "authValue" {
  description = "Header auth value"
  type        = string
  default     = "RandomKey"
}