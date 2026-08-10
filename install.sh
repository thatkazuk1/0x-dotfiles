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

# Symlink top-level dotfiles
for dotfile in .zshrc .vimrc .p10k.zsh; do
    TARGET="$HOME/$dotfile"
    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "Found existing file at $TARGET. Backing up to $TARGET.bak..."
        mv "$TARGET" "$TARGET.bak"
    fi
    echo "Symlinking $dotfile..."
    ln -sfn "$DOTFILES_DIR/$dotfile" "$TARGET"
done

echo "Dotfiles symlinked successfully!"
