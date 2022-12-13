variable "resource_group_name" {
  type = string
  description = "The name of the Resouce Group"
  default = "module_vm_windows2"
}


variable "location" {
    type = string
    description = "The location for the NSG"
    default = "AustraliaEast"
}



variable "tags" {
  type = map(any)
  description = "The tag values for the deployment"
  default = {
  "environment" = "lab"
  "owner" = "Ben"
}
}

variable "name" {
  type = string
  description = "Name of the Network Security Group"
  default = "nsg_name"
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "The values for each NSG rule "
  default = [
  {
    name                       = "AllowWebIn"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "AllowSSLIn"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "AllowRDPIn"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
} 





variable "vnet_windows_name" {
description = "Azure vnet name"
type        = string
default = "vNetWindows"
}

variable "address_space_windows_definition" {
description = "Defintion of the adress space"
type        = list(string)
default = [
    "10.0.0.0/16"
    ]
}

variable "subnet_windows_name" {
description = "Azure subnet name"
type        = string
default = "subnetwindowsname"
}

variable "address_prefixes_windows_definition" {
description = "Definition of the address prefixes"
type        = list(string) 
default =  [
    "10.0.2.0/24"
    ]  
}

variable "private_ip_allocation_windows_definition" {
description = "Azure private ip alocation dynamic or static"
type        = string
default = "Dynamic"
}

variable "nombre_de_vm_windows" {
description = "nombre de machines virtuel"
type        = number
default = 1
}




variable "size_vm_windows_definition" {
description = "Name of the default type size"
type        = string
default = "Standard_F2"
}

variable "user_windows_name" {
description = "Name of the default user"
type        = string
default = "adminuser"    
}

variable "source_image" {
description = "les sources de l image windows, server ou client, publishern offer, sku, version"
type        = list(string)
default = [
    "MicrosoftWindowsDesktop",
    "Windows-10",
    "19h2-pro-g2",
    "latest"
    ]
}

