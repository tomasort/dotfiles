#!/bin/bash

# Define paths
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"

# Function to remove empty parent directories
remove_empty_parents() {
    local dir="$1"
    while [ "$dir" != "$HOME_DIR" ] && [ -d "$dir" ]; do
        if [ -z "$(ls -A "$dir")" ]; then
            echo "Removing empty parent directory: $dir"
            rmdir "$dir"
            dir="$(dirname "$dir")"
        else
            break
        fi
    done
}

echo "Checking for potential stow conflicts..."

find "$DOTFILES_DIR" -type f -o -type l | grep -v "\.git/" | while read -r file; do
    rel_path="${file#$DOTFILES_DIR/}"
    target="$HOME_DIR/$rel_path"
    # If target exists and is not a symlink, remove it
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Removing conflict: $target"
        rm -rf "$target"
        # Check if parent directory is now empty and remove if needed
        parent_dir="$(dirname "$target")"
        remove_empty_parents "$parent_dir"
    fi
done
