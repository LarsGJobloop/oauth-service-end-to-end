# We dont want to provide any defaults here, as we want the consumer to
# be explicit about what they want to deploy.

variable "compose_app_repo" {
  description = "The repository containing the compose app"
  type        = string
}

variable "compose_app_branch" {
  description = "The branch of the repository containing the compose app"
  type        = string
}

variable "compose_app_path" {
  description = "The path to the compose app"
  type        = string
}

# !TODO: Setup a test for this
variable "reconciliation_intervall" {
  description = "How often the reconciliation should run (e.g. 30s, 10min, 1h 30min, 2d)"
  type        = string

  # This is used for systemd timer, so it needs to be a valid duration.
  # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
  validation {
    condition     = can(regex("^([0-9]+(s|sec|m|min|h|hr|d|day))(\\s+([0-9]+(s|sec|m|min|h|hr|d|day)))*$", var.reconciliation_intervall))
    error_message = "reconciliation_intervall must be a space-separated sequence of durations like '30s', '10min', '1h 30min', '2d'."
  }
}

variable "ssh_key_id" {
  description = "A reference to a SSH key in the Hetzner Cloud"
  type        = string
}

variable "server_type" {
  description = "The type of the server. Defaults to a small server with 2 vCPU, 4GB RAM, 40GB SSD"
  type        = string
  default     = "cx22" # 2 vCPU, 4GB RAM, 40GB SSD
}

variable "location" {
  description = "The location of the server. Defaults to Helsinki, Finland"
  type        = string
  default     = "hel1" # Helsinki, Finland
}
