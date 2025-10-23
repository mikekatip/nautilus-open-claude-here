#!/bin/bash

EXTENSION_DIR="$HOME/.local/share/nautilus-python/extensions"
SCRIPT_NAME="nautilus-open-claude-here.py"

echo "Installing Open Claude Code Here extension for Nautilus..."

# Detect package manager and install nautilus-python if needed
if type pacman &> /dev/null; then
    if ! pacman -Q nautilus-python &> /dev/null; then
        echo "Installing nautilus-python with pacman..."
        sudo pacman -S nautilus-python --noconfirm
    fi
elif type apt-get &> /dev/null; then
    if ! dpkg -l | grep -q python3-nautilus; then
        echo "Installing python3-nautilus with apt-get..."
        sudo apt-get install -y python3-nautilus
    fi
elif type dnf &> /dev/null; then
    if ! rpm -q nautilus-python &> /dev/null; then
        echo "Installing nautilus-python with dnf..."
        sudo dnf install -y nautilus-python
    fi
else
    echo "Warning: Could not detect package manager. Please install nautilus-python manually."
fi

# Create extension directory if it doesn't exist
mkdir -p "$EXTENSION_DIR"

# Copy the script to the extension directory
if [ -f "$SCRIPT_NAME" ]; then
    echo "Copying $SCRIPT_NAME to $EXTENSION_DIR..."
    cp "$SCRIPT_NAME" "$EXTENSION_DIR/"
    chmod +x "$EXTENSION_DIR/$SCRIPT_NAME"
else
    echo "Error: $SCRIPT_NAME not found in current directory."
    echo "Please run this script from the same directory as $SCRIPT_NAME"
    exit 1
fi

# Clear Python cache to ensure fresh load
if [ -d "$EXTENSION_DIR/__pycache__" ]; then
    echo "Clearing Python cache..."
    rm -rf "$EXTENSION_DIR/__pycache__"
fi

# Restart Nautilus
echo "Restarting Nautilus..."
nautilus -q

echo "Installation complete! Right-click in any folder in Nautilus to see 'Open Claude Code Here' option."
