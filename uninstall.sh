#!/bin/bash

set -e

echo "Uninstalling Kanata home row mods configuration..."

# Stop and disable the service
if systemctl --user is-active --quiet kanata.service; then
    echo "Stopping kanata service..."
    systemctl --user stop kanata.service
fi

if systemctl --user is-enabled --quiet kanata.service; then
    echo "Disabling kanata service..."
    systemctl --user disable kanata.service
fi

# Remove systemd service file
if [ -f "$HOME/.config/systemd/user/kanata.service" ]; then
    echo "Removing systemd service file..."
    rm "$HOME/.config/systemd/user/kanata.service"
fi

# Reload systemd
echo "Reloading systemd daemon..."
systemctl --user daemon-reload

# Ask about config file removal
echo ""
read -p "Do you want to remove the kanata configuration file? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$HOME/.config/kanata/config.kbd" ]; then
        echo "Removing kanata configuration..."
        rm "$HOME/.config/kanata/config.kbd"
        rmdir "$HOME/.config/kanata" 2>/dev/null || true
    fi
    echo "Configuration removed."
else
    echo "Configuration kept at: $HOME/.config/kanata/config.kbd"
fi

echo ""
echo "Uninstallation complete!"
echo "Note: The kanata binary at ~/.local/bin/kanata was not removed."
echo "To remove it, run: rm ~/.local/bin/kanata"
