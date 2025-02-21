resource "volterra_securemesh_site_v2" "xc-securemesh-site" {
  name                    = format("%s-site-%s", var.resource_prefix, random_id.suffix.hex)
  namespace               = "system"
  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = local.f5xc_node_count > 1 ? true : false

  labels = {
    "ves.io/provider" = "ves-io-AZURE"
  }

  offline_survivability_mode {
    enable_offline_survivability_mode = true
  }

  re_select {
    geo_proximity = true
  }

  azure {
    not_managed {}
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
    create_before_destroy = true
  }
}

resource "volterra_token" "smsv2-token" {
  name      = "${var.resource_prefix}-token-${random_id.suffix.hex}"
  namespace = "system"
  type      = 1
  site_name = volterra_securemesh_site_v2.xc-securemesh-site.name
}


data "cloudinit_config" "f5xc-ce_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("./template/user-data.tpl", { token = volterra_token.smsv2-token.id })
  }
}

