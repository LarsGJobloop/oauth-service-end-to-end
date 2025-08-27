locals {
  reconciliation_script = templatefile("${path.module}/reconciliation.sh", {
    git_remote   = var.compose_app_repo
    branch       = var.compose_app_branch
    compose_path = var.compose_app_path
  })

  cloud_config = templatefile("${path.module}/cloud-config.yaml", {
    boot_delay               = 10
    reconciliation_intervall = var.reconciliation_intervall
    # Careful with the indentation here, it's a bit hacky to embed it correctly in the template.
    indented_reconciliation_script = indent(6, local.reconciliation_script)
  })
}

# Forward the rendered reconciliation script and cloud-config to the consumer
# for debugging and snapshot testing.
output "reconciliation_script" {
  value = local.reconciliation_script
}
output "cloud_config" {
  value = local.cloud_config
}

resource "hcloud_server" "server" {
  name  = "server"
  image = "debian-12"

  server_type = var.server_type
  location    = var.location

  ssh_keys = [
    var.ssh_key_id
  ]

  user_data = local.cloud_config
}

output "server_ip" {
  value = hcloud_server.server.ipv4_address
}
