#!/bin/bash

EXTENSION_DIR="$HOME/.local/share/nautilus-python/extensions"
SCRIPT_NAME="nautilus-open-claude-here.py"
DOWNLOAD_URL="https://raw.githubusercontent.com/mikekatip/nautilus-open-claude-here/refs/heads/main/nautilus-open-claude-here.py"

echo "Installing Open Claude Code Here extension for Nautilus..."

# Check if the script exists locally, otherwise download from GitHub
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Downloading $SCRIPT_NAME from GitHub..."
    if command -v curl &> /dev/null; then
        curl -fsSL "$DOWNLOAD_URL" -o "$SCRIPT_NAME"
    elif command -v wget &> /dev/null; then
        wget -q "$DOWNLOAD_URL" -O "$SCRIPT_NAME"
    else
        echo "Error: Neither curl nor wget found. Please install one of them."
        exit 1
    fi

    if [ ! -f "$SCRIPT_NAME" ]; then
        echo "Error: Failed to download $SCRIPT_NAME"
        exit 1
    fi

    echo "Download complete."
else
    echo "Using local $SCRIPT_NAME file."
fi

# Detect package manager and install required dependencies
if type pacman &> /dev/null; then
    echo "Detected Arch Linux (pacman)..."
    PACKAGES_TO_INSTALL=()

    # Check and add missing packages
    for pkg in nautilus-python python-gobject gtk4 nautilus; do
        if ! pacman -Q $pkg &> /dev/null; then
            PACKAGES_TO_INSTALL+=($pkg)
        fi
    done

    if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
        echo "Installing required packages: ${PACKAGES_TO_INSTALL[@]}"
        sudo pacman -S --noconfirm "${PACKAGES_TO_INSTALL[@]}"
    else
        echo "All required packages are already installed."
    fi

elif type apt-get &> /dev/null; then
    echo "Detected Debian/Ubuntu (apt)..."
    PACKAGES_TO_INSTALL=()

    # Check and add missing packages
    for pkg in python3-nautilus python3-gi gir1.2-gtk-4.0 nautilus; do
        if ! dpkg -l | grep -q "^ii.*$pkg"; then
            PACKAGES_TO_INSTALL+=($pkg)
        fi
    done

    if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
        echo "Installing required packages: ${PACKAGES_TO_INSTALL[@]}"
        sudo apt-get update
        sudo apt-get install -y "${PACKAGES_TO_INSTALL[@]}"
    else
        echo "All required packages are already installed."
    fi

elif type dnf &> /dev/null; then
    echo "Detected Fedora/RHEL (dnf)..."
    PACKAGES_TO_INSTALL=()

    # Check and add missing packages
    for pkg in nautilus-python python3-gobject gtk4 nautilus; do
        if ! rpm -q $pkg &> /dev/null; then
            PACKAGES_TO_INSTALL+=($pkg)
        fi
    done

    if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
        echo "Installing required packages: ${PACKAGES_TO_INSTALL[@]}"
        sudo dnf install -y "${PACKAGES_TO_INSTALL[@]}"
    else
        echo "All required packages are already installed."
    fi

else
    echo "Warning: Could not detect package manager (pacman, apt, or dnf)."
    echo "Please install the following packages manually:"
    echo "  - nautilus-python (or python3-nautilus)"
    echo "  - python-gobject (or python3-gobject)"
    echo "  - gtk4"
    echo "  - nautilus"
    exit 1
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
