variable "prefix" {
  type    = string
  default = "iac"
}
variable "location" {
  type    = string
  default = "East US"
}
variable "vnet_address_space" {
  type    = list(string)
  default = ["10.20.0.0/16"]
}
variable "address_prefex" {
  type    = list(string)
  default = ["10.20.0.0/24"]
}
variable "linux_vm_name" {
  type    = string
  default = "linvm"
}
variable "Windows_vm_name" {
  type    = string
  default = "winvm"
}

variable "adminuser" {
  type    = string
  default = "testadmin"

}
variable "adminpwd" {
  type    = string
  default = "P@ssword@123"

}