#!/bin/bash
# This is a **TEMPLATE** for a script that is used to reconcile the gitops repository and pull the latest changes.
# Terraform replaces variables here with the actual values.

# It is straightforward with no error handling, optimizations or hardening.
# Use it as a reference and take into consideration the following (feel free to use LLMs to help you):
# - Who is running this script.
# - Where are application logs written.
# - Where are application data written.
# - Where are application secrets written.
# - What if there's no changes in since last check?
# - What if the repository is private?
# - What if the container fails to start?

# Standard bash error handling
set -euo pipefail

# Global variables
REPOSITORY_DIRECTORY="/srv/gitops/repo"
COMPOSE_FILE="$REPOSITORY_DIRECTORY/${compose_path}"


# Check if the repository directory exists
if [ ! -d "$REPOSITORY_DIRECTORY/.git" ]; then
    # Clone the repository
    echo "[INFO] Initial clone of repo..."
    git clone --branch "${branch}" "${git_remote}" "$REPOSITORY_DIRECTORY"
else
    # Update the existing repository
    echo "[INFO] Updating existing repo..."
    git -C "$REPOSITORY_DIRECTORY" pull
fi

# Pull the latest changes
docker compose --file "$COMPOSE_FILE" pull

# Replace the existing container with the new one, removing any orphaned containers
docker compose --file "$COMPOSE_FILE" up --detach --remove-orphans

# Log the end of the script
echo "[INFO] Reconciliation complete"