variable "resource_group_name" {
  type    = string
  default = "devops-hw9--res-group"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "vm_count" {
  type    = number
  default = 2
}