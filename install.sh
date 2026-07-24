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
)

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    # If the target exists and is a directory (not a symlink), we need to back it up or remove it
    TARGET="$CONFIG_DIR/$pkg"
    if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "Found existing directory at $TARGET. Backing up to $TARGET.bak..."
        mv "$TARGET" "$TARGET.bak"
    fi
    stow -t "$CONFIG_DIR" "$pkg"
done

echo "Dotfiles stowed successfully!"
