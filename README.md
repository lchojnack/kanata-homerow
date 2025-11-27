# Kanata Home Row Mods Setup

Advanced home row mods configuration with automatic typing layer and mouse control for Kanata on Linux.

## Features

- **GACS Home Row Mods** - Optimized per-finger timing (Shift: 160ms, Ctrl: 300ms, Alt: 400ms, Meta: 450ms)
- **Automatic Typing Layer** - Prevents false mod triggers during fast typing
- **Filtered Bigrams** - Special handling for common letter combinations (as, sa, ko, li)
- **Mouse Control Layer** - Navigate and click with keyboard via Caps Lock toggle
- **Smart Configuration** - Based on community best practices from Kanata discussions

## Files

- `kanata.kbd` - Advanced Kanata configuration
- `kanata.service` - Systemd user service
- `install.sh` - Installation script with restart option
- `uninstall.sh` - Uninstallation script

## Home Row Mods Layout (GACS)

**Left hand:**
- `a` → Meta/Super (450ms hold time)
- `s` → Alt (400ms hold time)
- `d` → Ctrl (300ms hold time)
- `f` → Shift (160ms hold time)

**Right hand:**
- `j` → Shift (160ms hold time)
- `k` → Ctrl (300ms hold time)
- `l` → Alt (400ms hold time)
- `;` → Meta/Super (450ms hold time)

## Mouse Control Layer

Toggle mouse mode by tapping **Caps Lock**:

**Cursor Movement:**
- `j` → Move left
- `k` → Move down
- `l` → Move up
- `;` → Move right

**Mouse Buttons:**
- `n` → Left click
- `m` → Right click

**Scrolling:**
- `,` → Scroll down
- `.` → Scroll up

**Exit:** Tap Caps Lock again to return to normal typing

## Installation

### Prerequisites

You need to have Kanata installed. If not installed, download it from:
https://github.com/jtroo/kanata/releases

The install script checks for kanata in your PATH or at `~/.local/bin/kanata`.

### Install

**First time installation:**
```bash
./install.sh
```

**Update configuration (restarts service):**
```bash
./install.sh --restart
# or
./install.sh -r
```

This will:
1. Copy the configuration to `~/.config/kanata/config.kbd`
2. Install the systemd service to `~/.config/systemd/user/kanata.service`
3. Enable and start/restart the service

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
./install.sh -r  # Installs and restarts in one command
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

## Configuration Details

This configuration implements advanced techniques from the Kanata community:

- **Automatic Typing Layer**: Switches to a plain layer during fast typing (returns to base after 55ms idle)
- **Per-Finger Timing**: Faster activation for frequently-used mods (Shift), slower for rarely-used (Meta)
- **Filtered Bigrams**: Prevents false triggers on common letter combinations
- **Tap-time**: 220ms for distinguishing taps from holds

Optimized for typing speeds between 40-70 WPM.

## References

- [Kanata GitHub](https://github.com/jtroo/kanata)
- [Kanata Linux Setup Guide](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md)
- [Advanced HRM Discussion](https://github.com/jtroo/kanata/discussions/1656)
- [Precondition's HRM Guide](https://precondition.github.io/home-row-mods)
