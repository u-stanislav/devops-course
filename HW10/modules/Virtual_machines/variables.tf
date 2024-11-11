variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "location" {
  description = "The location where the VMs will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "availability_set_id" {
  description = "ID of the availability set"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the VMs"
  type        = string
}

variable "lb_backend_pool_id" {
  description = "ID of the load balancer backend pool"
  type        = string
}

variable "vm_size" {
  description = "The size of the VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key to access the VMs"
  type        = string
}