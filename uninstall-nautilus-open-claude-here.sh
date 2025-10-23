#!/bin/bash

EXTENSION_DIR="$HOME/.local/share/nautilus-python/extensions"
SCRIPT_NAME="nautilus-open-claude-here.py"

echo "Uninstalling Open Claude Code Here extension for Nautilus..."

# Remove the extension script
if [ -f "$EXTENSION_DIR/$SCRIPT_NAME" ]; then
    echo "Removing $EXTENSION_DIR/$SCRIPT_NAME..."
    rm "$EXTENSION_DIR/$SCRIPT_NAME"
else
    echo "Extension not found at $EXTENSION_DIR/$SCRIPT_NAME"
fi

# Clear Python cache
if [ -d "$EXTENSION_DIR/__pycache__" ]; then
    echo "Clearing Python cache..."
    rm -rf "$EXTENSION_DIR/__pycache__"
fi

# Restart Nautilus
echo "Restarting Nautilus..."
nautilus -q
sleep 1

echo "Uninstallation complete! The 'Open Claude Code Here' option has been removed."
