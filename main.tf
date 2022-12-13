/*-----------------Création de la ressource de la ressource group--------------
 Cette ressource va servir à la création d'une ressource group
 
 Plus d'infos sur ce lien<https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>


#Create the Resouce Group
resource "azurerm_resource_group" "resouce_group" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
*/
/*-----------------Création de la ressource vnet --------------
 Cette ressource va servir à la création d'un réseau virtuel comprenant tous les sous-réseaux configurés. 
 Chaque sous-réseau peut éventuellement être configuré avec un groupe de sécurité à associer au sous-réseau.
 
 Plus d'infos sur ce lien<https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
*/
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_windows_name
  address_space       = var.address_space_windows_definition
  location            = var.location
  resource_group_name = var.resource_group_name
}

/*-----------------Création de la ressource de sous réseau--------------
 Cette ressource va servir à la création d'un sous-réseau. 
 Les sous-réseaux représentent des segments de réseau dans l'espace IP défini par le réseau virtuel.
 
 Plus d'infos sur ce lien<https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
*/
resource "azurerm_subnet" "subnet" {
 
  name                 = var.subnet_windows_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes      = var.address_prefixes_windows_definition
}

/*-----------------Création de la ressource d'interface reseau--------------
 Cette ressource va servir à la création d'une interface réseau
 
 Plus d'infos sur ce lien<https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
*/
resource "azurerm_network_interface" "example" {
  count               = var.nombre_de_vm_windows  
  name                = "nicwindowname${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_allocation_windows_definition
  }
}

/*-----------------Création de la ressource de machine windows --------------
 Cette ressource va servir à la création d'une machine virtuel windows seulement.
 
 Plus d'infos sur ce lien<https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
*/
resource "azurerm_windows_virtual_machine" "example" {
  count               = var.nombre_de_vm_windows  
  name                = "vmwindowsname${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size_vm_windows_definition
  admin_username      = var.user_windows_name
  admin_password      = "P@$$w0rd1234!"
  #availability_set_id = azurerm_availability_set.DemoAset.id
  network_interface_ids = [
    element(azurerm_network_interface.example.*.id, count.index)
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher        = var.source_image[0]
    offer            = var.source_image[1]
    sku              = var.source_image[2]
    version          = var.source_image[3]
  }
}

/*-----------------Création de la ressource de security group-----------
Cette ressource va servir à la création des règles de security group. 
Ici, j'utilise la notion de Dynamic Blocks. 

Plus d'infos sur ce lien <https://www.youtube.com/watch?v=gL7FIUPvsXI&t=359s>
Le github utilisé pour le code du security group <https://github.com/tsrob50/TerraformExamples.git>
*/

resource "azurerm_network_security_group" "network_security_group" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
  
  tags = var.tags
}



/*-----------------Association de la ressource de security group et de la carte réseau-----------
Cette ressource va servir à ajouter les règles crée en amont à la VM. 
Association de la sécurity group avec la carte réseau 

Plus d'info ici <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association>
*/

resource "azurerm_subnet_network_security_group_association" "linux-vm-nsg-association" {
  depends_on=[azurerm_virtual_network.vnet,azurerm_network_security_group.network_security_group]
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}
