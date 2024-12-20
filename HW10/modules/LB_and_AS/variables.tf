variable "availability_set_name" {
  description = "The name of the availability set"
  type        = string
}

variable "load_balancer_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "location" {
  description = "The location/region where resources will be deployed"
  type        = string
  default = "francecentral"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the load balancer frontend"
  type        = string
}

variable "public_ip" {
  description = "The ID of the public_ip for the load balancer frontend"
  type        = string
}