# variable "resource_group_name" {
#   type        = string
#   default     = "terragroup"
#   description = "name of the res group"
# }

# variable "location" {
#   type    = string
#   default = "ukwest"
# }

variable "storageaccountname" {
  type    = string
  default = "Terrasto1624"
}

variable "tags" {
  default = {
    enivironment = "prod"
    department   = "IT"
  }
}

# variable "vnetname" {
#   type    = string
#   default = "terra-vnet"
# }


# variable "vnet_address" {
#   type    = list(any)
#   default = ["192.168.0.0/24"]
# }

# variable "subnet_name" {
#   type    = string
#   default = "arm_snet"
# }

# variable "sbnet_address" {
#   type    = list(any)
#   default = ["192.168.0.0/25"]
# }

variable "publicipname" {
  type    = string
  default = "terra_pip"
}


variable "nsgname" {
  type    = string
  default = "terransg"
}
variable "nicname" {
  type    = string
  default = "terranic"
}

variable "vmname" {
  type    = string
  default = "terravm"
}
variable "vm_size" {
  type    = string
  default = "Standard_Ds1_v2"
}
variable "adminname" {
  type    = string
  default = "terrauser"
}

# variable "adminpw" {
#   type = string
# }




