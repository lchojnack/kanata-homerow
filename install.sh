#!/bin/bash

set -e

echo "Installing Kanata home row mods configuration..."

# Check if kanata is installed
if ! command -v kanata &> /dev/null && [ ! -f "$HOME/.local/bin/kanata" ]; then
    echo "Error: kanata is not installed. Please install kanata first."
    echo "You can download it from: https://github.com/jtroo/kanata/releases"
    exit 1
fi

# Create necessary directories
echo "Creating configuration directories..."
mkdir -p "$HOME/.config/kanata"
mkdir -p "$HOME/.config/systemd/user"

# Copy kanata configuration
echo "Installing kanata configuration..."
cp kanata.kbd "$HOME/.config/kanata/config.kbd"

# Copy systemd service
echo "Installing systemd service..."
cp kanata.service "$HOME/.config/systemd/user/kanata.service"

# Reload systemd
echo "Reloading systemd daemon..."
systemctl --user daemon-reload

# Enable and start the service
echo "Enabling and starting kanata service..."
systemctl --user enable kanata.service
systemctl --user start kanata.service

# Check service status
echo ""
echo "Installation complete!"
echo ""
systemctl --user status kanata.service --no-pager

echo ""
echo "Kanata is now running with home row mods enabled."
echo "Home row mod layout:"
echo "  Left hand:  a=Super, s=Alt, d=Ctrl, f=Shift"
echo "  Right hand: j=Shift, k=Ctrl, l=Alt, ;=Super"
