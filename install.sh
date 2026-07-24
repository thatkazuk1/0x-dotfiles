#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Installing stow..."
sudo apt-get update
sudo apt-get install -y stow

echo "Applying dotfiles with GNU Stow..."
cd "$DOTFILES_DIR"

# Folders to stow
PACKAGES=(
    "hypr"
    "waybar"
    "eww"
    "swaync"
    "matugen"
    "nvim"
    "zsh"
)

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow -t "$HOME" "$pkg" --restow
done

echo "Dotfiles stowed successfully!"
