variable "server_ssh_key" {
  type        = string
  description = "Public part of the SSH key to access the server"
}

resource "hcloud_ssh_key" "server_ssh_key" {
  name = "server_ssh_key"
  public_key = var.server_ssh_key
}

module "demo_app" {
  source = "./hetzner-compose-app"

  # Repo to deploy
  compose_app_repo = "https://github.com/LarsGJobloop/oauth-service-end-to-end.git"
  compose_app_branch = "main"
  compose_app_path = "compose.yaml"

  # Reconciliation interval
  reconciliation_intervall = "10s"

  # SSH key to use for the server
  ssh_key_id = hcloud_ssh_key.server_ssh_key.id
}

output "app_address" {
  description = "The address of the demo app"
  value = module.demo_app.server_ip
}
