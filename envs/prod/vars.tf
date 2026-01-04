## backend.terraform 
variable "backend_bucket_name" {
  type = string
}

variable "backend_bucket_key" {
  type = string
}

variable "backend_region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}
