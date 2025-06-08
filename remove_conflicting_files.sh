#!/bin/bash

# Define paths
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

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

# Function to backup file/directory with preserved structure
backup_item() {
    local source="$1"
    local rel_path="${source#$HOME_DIR/}"
    local backup_target="$BACKUP_DIR/$rel_path"
    local backup_parent="$(dirname "$backup_target")"
    
    # Create parent directories in backup location
    mkdir -p "$backup_parent"
    
    # Move the item to backup location
    echo "Backing up: $source -> $backup_target"
    mv "$source" "$backup_target"
}

echo "Checking for potential stow conflicts..."
echo "Backup directory: $BACKUP_DIR"

find "$DOTFILES_DIR" -type f -o -type l | grep -v "\.git/" | while read -r file; do
    rel_path="${file#$DOTFILES_DIR/}"
    target="$HOME_DIR/$rel_path"
    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Found conflict: $target"
        backup_item "$target"
        # Check if parent directory is now empty and remove if needed
        parent_dir="$(dirname "$target")"
        remove_empty_parents "$parent_dir"
    fi
done

echo "Backup completed. Files saved to: $BACKUP_DIR"