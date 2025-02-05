resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  f5xc_node_count = var.f5xc_enable_ce_site_ha ? 3 : 1
}
