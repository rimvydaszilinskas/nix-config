#!/usr/bin/env bash
set -euo pipefail

# Pre-trust all brew taps before running nix-rebuild
# This prevents the interactive prompts during darwin-rebuild

TAPS=(
  "clowdhaus/taps"
  "dashlane/tap"
  "exoscale/tap"
  "go-task/tap"
  "terraform-linters/tap"
)

echo "Pre-trusting brew taps..."
brew trust "${TAPS[@]}" 2>/dev/null || true

echo "Running nix-rebuild..."
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
