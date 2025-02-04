variable "f5xc_api_url" {
  type        = string
  description = "Volterra tenant api url"
}

variable "f5xc_api_p12_file" {
  type        = string
  description = "Volterra API p12 file path"
}


variable "resource_prefix" {
  type        = string
  description = "Object Prefix"
}

variable "owner" {
  description = "Owner name tag"
}

variable "az_region" {
  description = "Azure region name"
  default     = "swedencentral"
}

variable "az_instance_type" {
  type    = string
  default = "Standard_B4as_v2"
}

variable "f5xc_node_count" {
  type = number
}

variable "ssh_key" {
  type = string

}
