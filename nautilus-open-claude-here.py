#!/usr/bin/env python3
from gi.repository import Nautilus, GObject, Gio
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

    def show_notification(self, title, message):
        """Show a desktop notification"""
        try:
            notification = Gio.Notification.new(title)
            notification.set_body(message)
            app = Gio.Application.get_default()
            if app:
                app.send_notification(None, notification)
        except Exception:
            pass  # Fail silently if notifications don't work

    def launch_claude(self, menu, path):
        # Check if Claude exists
        if not CLAUDE_PATH or not os.path.exists(CLAUDE_PATH):
            self.show_notification(
                "Claude Code Not Found",
                f"Claude Code executable not found at: {CLAUDE_PATH or 'PATH'}\n"
                "Please install Claude Code first."
            )
            return

        try:
            # Build the command based on the terminal
            if TERMINAL == 'alacritty':
                subprocess.Popen([TERMINAL, '--working-directory', path, '-e', CLAUDE_PATH], shell=False)
            elif TERMINAL == 'gnome-terminal':
                subprocess.Popen([TERMINAL, '--working-directory=' + path, '--', CLAUDE_PATH], shell=False)
            elif TERMINAL in ['konsole', 'xfce4-terminal']:
                subprocess.Popen([TERMINAL, '--workdir', path, '-e', CLAUDE_PATH], shell=False)
            else:
                # Generic fallback for xterm and others - use shell wrapper script
                wrapper = f'cd {shutil.quote(path)} && exec {shutil.quote(CLAUDE_PATH)}'
                subprocess.Popen([TERMINAL, '-e', 'sh', '-c', wrapper], shell=False)
        except Exception as e:
            self.show_notification(
                "Failed to Launch Claude Code",
                f"Error: {str(e)}"
            )

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
