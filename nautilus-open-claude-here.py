#!/usr/bin/env python3
from gi import require_version

require_version('Gtk', '4.0')
require_version('Nautilus', '4.0')

from gi.repository import Nautilus, GObject
import os, subprocess, shutil

# Detect the default terminal emulator
def get_terminal():
    terminals = ['alacritty', 'gnome-terminal', 'konsole', 'xfce4-terminal', 'xterm']
    for term in terminals:
        if shutil.which(term):
            return term
    return 'xterm'  # fallback

TERMINAL = get_terminal()
# Use shutil.which to find claude in PATH, fallback to common location
CLAUDE_PATH = shutil.which('claude') or os.path.expanduser('~/.local/bin/claude')

class ClaudeCodeHereExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()

    def launch_claude(self, menu, path):
        # Build the command based on the terminal
        if TERMINAL == 'alacritty':
            subprocess.Popen([TERMINAL, '--working-directory', path, '-e', CLAUDE_PATH], shell=False)
        elif TERMINAL == 'gnome-terminal':
            subprocess.Popen([TERMINAL, '--working-directory=' + path, '--', CLAUDE_PATH], shell=False)
        elif TERMINAL in ['konsole', 'xfce4-terminal']:
            subprocess.Popen([TERMINAL, '--workdir', path, '-e', CLAUDE_PATH], shell=False)
        else:
            # Generic fallback for xterm and others
            subprocess.Popen([TERMINAL, '-e', f'cd "{path}" && {CLAUDE_PATH}'], shell=True)

    def get_file_items(self, files):
        """Called when right-clicking on a file/folder"""
        if len(files) != 1:
            return []

        file_ = files[0]
        if not file_.is_directory():
            return []

        path = file_.get_location().get_path()
        if not path or not os.path.isdir(path):
            return []

        item = Nautilus.MenuItem(
            name="ClaudeCodeHereOpen",
            label="Open Claude Code Here",
            tip="Open Claude Code in the selected folder"
        )
        item.connect('activate', self.launch_claude, path)
        return [item]

    def get_background_items(self, directory):
        """Called when right-clicking on the background"""
        if not directory.is_directory():
            return []

        path = directory.get_location().get_path()
        if not path or not os.path.isdir(path):
            return []

        item = Nautilus.MenuItem(
            name="ClaudeCodeHereOpenBackground",
            label="Open Claude Code Here",
            tip="Open Claude Code in the current folder"
        )
        item.connect('activate', self.launch_claude, path)
        return [item]
