# Kanata Home Row Mods Setup

This directory contains configuration files and installation scripts for setting up home row mods using Kanata on Linux.

## Files

- `kanata.kbd` - Kanata configuration with home row mods
- `kanata.service` - Systemd user service to run Kanata automatically
- `install.sh` - Installation script
- `uninstall.sh` - Uninstallation script

## Home Row Mods Layout

**Left hand:**
- `a` → Super/Win (when held)
- `s` → Alt (when held)
- `d` → Ctrl (when held)
- `f` → Shift (when held)

**Right hand:**
- `j` → Shift (when held)
- `k` → Ctrl (when held)
- `l` → Alt (when held)
- `;` → Super/Win (when held)

## Installation

### Prerequisites

You need to have Kanata installed. If not installed, download it from:
https://github.com/jtroo/kanata/releases

The install script checks for kanata in your PATH or at `~/.local/bin/kanata`.

### Install

```bash
./install.sh
```

This will:
1. Copy the configuration to `~/.config/kanata/config.kbd`
2. Install the systemd service to `~/.config/systemd/user/kanata.service`
3. Enable and start the service

### Permissions Setup

Kanata requires permissions to access input devices. You may need to:

1. Create udev rules:
   ```bash
   echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/kanata.rules
   ```

2. Add your user to required groups:
   ```bash
   sudo groupadd --system uinput
   sudo usermod -aG input $USER
   sudo usermod -aG uinput $USER
   ```

3. Reload udev rules:
   ```bash
   sudo udevadm control --reload-rules && sudo udevadm trigger
   ```

4. Load uinput module:
   ```bash
   sudo modprobe uinput
   echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
   ```

5. **Log out and log back in** for group changes to take effect.

## Uninstallation

```bash
./uninstall.sh
```

This will:
1. Stop and disable the kanata service
2. Remove the systemd service file
3. Optionally remove the configuration file

## Managing the Service

Check status:
```bash
systemctl --user status kanata.service
```

Stop service:
```bash
systemctl --user stop kanata.service
```

Start service:
```bash
systemctl --user start kanata.service
```

Restart service:
```bash
systemctl --user restart kanata.service
```

View logs:
```bash
journalctl --user -u kanata.service -f
```

## Customization

Edit `kanata.kbd` to customize your configuration, then run:
```bash
./install.sh
systemctl --user restart kanata.service
```

## Troubleshooting

### Permission Denied Errors

If you see "Permission denied" errors, make sure you've completed all steps in the Permissions Setup section and logged out/in.

### Service Won't Start

Check the service logs:
```bash
systemctl --user status kanata.service
journalctl --user -u kanata.service
```

### Home Row Mods Not Working

1. Check if the service is running: `systemctl --user status kanata.service`
2. Test your keyboard is detected: `sudo evtest` and select your keyboard
3. Verify the config file syntax is valid

## References

- [Kanata GitHub](https://github.com/jtroo/kanata)
- [Kanata Linux Setup Guide](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md)
- [Dreams of Code Home Row Mods](https://github.com/dreamsofcode-io/home-row-mods)
