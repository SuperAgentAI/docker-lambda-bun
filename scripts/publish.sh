#!/usr/bin/env bash

# Publish script
# This script generates a list of tags based on provided arguments.
# Usage:
#   ./publish.sh -v <version> -l <true|false> -a <arm64|x86_64>

set -euo pipefail

# Logging function for errors
err() {
  echo "Error: $*" >&2
  exit 1
}

# Function: publish::get_tags
# Generates a list of tags based on provided arguments.
# Arguments:
#   -v | --version [version]
#   -l | --latest [true | false | default = true]
#   -a | --arch [arm64 | x86_64 | default = x86_64]
publish::get_tags() {
  local version=""
  local latest="true"
  local arch="x86_64"
  local tags=()

  local default_arch="x86_64"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -v|--version)
        version="$2"
        shift 2
        ;;
      -l|--latest)
        latest="$2"
        shift 2
        ;;
      -a|--arch)
        arch="$2"
        shift 2
        ;;
      *)
        err "Unknown argument: $1"
        ;;
    esac
  done

  # Validate inputs
  if [[ -z "$version" ]]; then
    err "The version (-v | --version) argument is required."
  fi

  if [[ "$arch" != "arm64" && "$arch" != "x86_64" ]]; then
    err "Invalid architecture: $arch. Must be 'arm64' or 'x86_64'."
  fi

  # Split version into components
  IFS='.' read -r major minor patch <<<"${version}"

  # Generate tags based on the provided arguments
  if [[ "$latest" == "true" ]]; then
    if [[ "$arch" == "$default_arch" ]]; then
      tags+=("latest")
    fi
    tags+=("latest-${arch}")
  fi

  # Add version tags
  if [[ "$arch" == "$default_arch" ]]; then
    tags+=("${version}")
    [[ -n "$minor" ]] && tags+=("${major}.${minor}")
    tags+=("${major}")
  fi

  # Add version tags with architecture
  tags+=("${version}-${arch}")
  [[ -n "$minor" ]] && tags+=("${major}.${minor}-${arch}")
  tags+=("${major}-${arch}")

  # Output the final list of tags
  for tag in "${tags[@]}"; do
    echo "$tag"
  done
}

# Main function
publish() {
  publish::get_tags "$@"
}

# Execute the script if it is not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  publish "$@"
fi
