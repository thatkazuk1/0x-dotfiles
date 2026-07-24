#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Applying dotfiles by creating symlinks..."

# Ensure ~/.config exists
mkdir -p "$CONFIG_DIR"

# Symlink all folders under .config
for config_dir in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$config_dir" ]; then
        dir_name=$(basename "$config_dir")
        TARGET="$CONFIG_DIR/$dir_name"

        # Backup existing directory if it's not a symlink
        if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
            echo "Found existing directory at $TARGET. Backing up to $TARGET.bak..."
            mv "$TARGET" "$TARGET.bak"
        fi

        echo "Symlinking $dir_name..."
        ln -sfn "$config_dir" "$TARGET"
    fi
done

# Symlink .zshrc
TARGET_ZSHRC="$HOME/.zshrc"
if [ -f "$TARGET_ZSHRC" ] && [ ! -L "$TARGET_ZSHRC" ]; then
    echo "Found existing file at $TARGET_ZSHRC. Backing up to $TARGET_ZSHRC.bak..."
    mv "$TARGET_ZSHRC" "$TARGET_ZSHRC.bak"
fi
echo "Symlinking .zshrc..."
ln -sfn "$DOTFILES_DIR/.zshrc" "$TARGET_ZSHRC"

echo "Dotfiles symlinked successfully!"
