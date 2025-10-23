# Nautilus Open Claude Here

A Nautilus extension that adds a convenient context menu option to open [Claude Code](https://claude.com/claude-code) in any directory directly from the file manager.

## Features

- Right-click on any folder in Nautilus to open Claude Code in that directory
- Right-click on empty space in any folder to open Claude Code in the current directory
- Automatic terminal emulator detection (supports Alacritty, GNOME Terminal, Konsole, xfce4-terminal, xterm)
- Simple installation and uninstallation scripts

## Prerequisites

- **Claude Code**: Must be installed and available in your PATH (get it from [claude.com/claude-code](https://claude.com/claude-code))
  - The extension will automatically find `claude` in your PATH
  - If not in PATH, it will fall back to `~/.local/bin/claude`
- **nautilus-python**: Required for Nautilus extensions
- **A terminal emulator**: One of the supported terminals (alacritty, gnome-terminal, konsole, xfce4-terminal, or xterm)

## Installation

### Quick Install (Recommended)

Run this one-liner to install directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/mikekatip/nautilus-open-claude-here/main/install-nautilus-open-claude-here.sh | bash
```

### Manual Install

1. Clone or download this repository:
```bash
git clone https://github.com/mikekatip/nautilus-open-claude-here.git
cd nautilus-open-claude-here
```

2. Run the installation script:
```bash
chmod +x install-nautilus-open-claude-here.sh
./install-nautilus-open-claude-here.sh
```

### What the installation script does:
- Automatically detect your package manager and install `nautilus-python` if needed (supports pacman, apt-get, and dnf)
- Copy the extension to `~/.local/share/nautilus-python/extensions/`
- Restart Nautilus to load the extension

3. The "Open Claude Code Here" option should now appear in your Nautilus context menus!

## Usage

### Open in a specific folder:
1. Navigate to any directory in Nautilus
2. Right-click on a folder
3. Select "Open Claude Code Here"
4. Claude Code will open in your terminal at that folder location

### Open in current directory:
1. Navigate to any directory in Nautilus
2. Right-click on empty space (the background)
3. Select "Open Claude Code Here"
4. Claude Code will open in your terminal at the current directory

## Uninstallation

To remove the extension:

```bash
chmod +x uninstall-nautilus-open-claude-here.sh
./uninstall-nautilus-open-claude-here.sh
```

This will remove the extension and restart Nautilus.

## Supported Distributions

The installation script supports the following package managers:
- **Arch Linux** (pacman)
- **Debian/Ubuntu** (apt-get)
- **Fedora/RHEL** (dnf)

For other distributions, install `nautilus-python` manually using your package manager before running the installation script.

## Supported Terminal Emulators

The extension automatically detects and supports:
- Alacritty
- GNOME Terminal
- Konsole
- xfce4-terminal
- xterm (fallback)

## Troubleshooting

### The menu option doesn't appear
1. Make sure nautilus-python is installed:
   - Arch: `pacman -Q nautilus-python`
   - Debian/Ubuntu: `dpkg -l | grep python3-nautilus`
   - Fedora: `rpm -q nautilus-python`
2. Restart Nautilus: `nautilus -q`
3. Check if the extension file exists: `ls ~/.local/share/nautilus-python/extensions/`

### Claude Code doesn't launch
1. Verify Claude Code is installed: `which claude` or `ls ~/.local/bin/claude`
2. Make sure Claude Code is in your PATH or located at `~/.local/bin/claude`
3. Make sure Claude Code is executable: `chmod +x $(which claude)` or `chmod +x ~/.local/bin/claude`
4. Test Claude Code from terminal: `claude`

### Wrong terminal opens
The extension detects terminal emulators in this order: alacritty, gnome-terminal, konsole, xfce4-terminal, xterm. To use a different terminal, ensure it's in your PATH before others, or modify `nautilus-open-claude-here.py` line 12.

## License

MIT License - feel free to use, modify, and distribute as needed.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests on [GitHub](https://github.com/mikekatip/nautilus-open-claude-here).
