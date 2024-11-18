variable "resource_group_name" {
  type    = string
  default = "devops-hw9--res-group"
}

variable "location" {
  type    = string
  default = "Germany West Central"
}

variable "allowed_ips" {
  type    = list(string)
  default = ["195.24.131.82", "85.198.144.34", "91.193.129.182", "91.204.120.178", "92.119.220.145", "109.87.190.6", "40.91.223.95"] 
}

variable "env_name" {
  description = "environment name"
  type        = string
  default     = "hw9"
}

variable "private_key_paths" {
  default = [".//presets/id_rsa_0", ".//presets/id_rsa_1"]
}

variable "public_key_paths" {
  default = [".//presets/id_rsa_0.pub", ".//presets/id_rsa_1.pub"]
}
