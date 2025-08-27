terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.52.0"
    }
  }
}

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

provider "hcloud" {
  token = var.hcloud_token
}
