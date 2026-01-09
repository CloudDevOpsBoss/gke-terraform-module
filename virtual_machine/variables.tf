variable "project_id" {
  type        = string
  description = "default"
}
variable "region" {
  type        = string
  description = "default"
}
variable "zone" {
  type        = string
  description = "default"
}
variable "service_account_name" {
  type        = string
  description = "Name of the Service Account for the VM"
}
variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine"
}
variable "machine_type" {
  type        = string
  description = "Type of the Virtual Machine"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC Network"
  
}