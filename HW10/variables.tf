variable "resource_group_name" {
  type    = string
  default = "devops-hw10-res-group"
}

variable "location" {
  type    = string
  default = "France Central-Paris"
}

variable "allowed_ips" {
  type    = list(string)
  default = ["195.24.131.82", "85.198.144.34", "91.193.129.182", "91.204.120.178", "92.119.220.145", "109.87.190.6"] 
}

variable "env_name" {
  description = "environment name"
  type        = string
  default     = "hw10"
}

variable "project_name" {
  type    = string
  default = "hw10"
}

variable "public_key_path" {
  default = "../HW9/presets/id_rsa_0.pub"
}
