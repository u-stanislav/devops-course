variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "The location/region where resources will be deployed"
  type        = string
  default = "France Central-Paris"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
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