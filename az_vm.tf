resource "azurerm_linux_virtual_machine" "f5_xc_ce_nodes" {
  count                 = var.f5xc_node_count
  resource_group_name   = azurerm_resource_group.rg.name
  name                  = "${var.resource_prefix}-node-${count.index}"
  location              = azurerm_resource_group.rg.location
  size                  = var.az_instance_type
  network_interface_ids = [azurerm_network_interface.ce-node-SLO-nic[count.index].id]

  admin_username = "volterra-admin"

  admin_ssh_key {
    username   = "volterra-admin"
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "f5xccebyol"
    publisher = "f5-networks"
    product   = "f5xc_customer_edge"
  }

  source_image_reference {
    publisher = "f5-networks"
    offer     = "f5xc_customer_edge"
    sku       = "f5xccebyol"
    version   = "2024.44.1"

  }
  custom_data = base64encode(data.cloudinit_config.f5xc-ce_config.rendered)
  depends_on  = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip" "f5_xc_ce_nodes_pub-ip" {
  count               = var.f5xc_node_count
  name                = "ce-node-${count.index}-pub-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ce-node-SLO-nic" {
  count               = var.f5xc_node_count
  name                = "${var.resource_prefix}-ce-node-${count.index}-slo-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ce-slo"
    subnet_id                     = azurerm_subnet.ext_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.f5_xc_ce_nodes_pub-ip[count.index].id
  }
}
