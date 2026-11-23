# <img src="icons/caffeine-inactive.svg" alt="" width="40" height="40" align="center"> Caffeine Fix for Wayland <img src="icons/caffeine-active.svg" alt="" width="40" height="40" align="center">

A simple, lightweight caffeine/stay-awake utility for Linux systems running Wayland, particularly GNOME. This tool prevents your system from going to sleep or locking the screen, perfect for presentations, watching videos, or any time you need to keep your system active.

## Features

- 🌊 **Wayland Compatible** - Works natively with Wayland display servers
- 🖥️ **System Tray Indicator** - Easy-to-use system tray icon for quick access
- ⌨️ **CLI Support** - Command-line interface for scripting and automation
- 🔔 **Desktop Notifications** - Visual feedback when toggling caffeine on/off
- 💤 **Status Monitoring** - Real-time status display in system tray
- 🪶 **Lightweight** - Minimal resource usage, uses native GNOME tools

## Components

### 1. System Tray Indicator (`caffeine-fix-indicator`)
A Python-based system tray application that provides a visual interface with:
- Espresso cup tray icon that changes with status (steaming cup on a blue saucer = active, empty grey cup = inactive)
- Click to toggle sleep prevention on/off
- Status display in the menu
- Desktop notifications

### 2. CLI Tool (`caffeine-fix`)
A bash script for command-line control with commands:
- `toggle` - Switch between active/inactive
- `on` - Enable sleep prevention
- `off` - Disable sleep prevention
- `status` - Check current state

## Requirements

### System Dependencies
- **GNOME Session** - Uses `gnome-session-inhibit` for sleep prevention
- **Python 3** - For the indicator application
- **libayatana-appindicator-glib** (`AyatanaAppIndicatorGlib` 2.0) - For the system tray icon and menu (no GTK required)
- **notify-send** - For desktop notifications (optional)

### Ubuntu/Debian
```bash
sudo apt install python3-gi gir1.2-ayatanaappindicatorglib-2.0 gnome-session libnotify-bin
```

### Fedora
```bash
sudo dnf install python3-gobject libayatana-appindicator-glib gnome-session libnotify
```

### Arch Linux
```bash
sudo pacman -S python-gobject libayatana-appindicator-glib gnome-session libnotify
```

## Installation

### Automated Installation
```bash
./install.sh
```

This will:
- Copy scripts to `~/bin/`
- Set executable permissions
- Create desktop entry for autostart (optional)
- Install tray icons to `~/.local/share/icons/hicolor/scalable/apps/`
- Check for required dependencies

### Manual Installation

1. **Copy the scripts:**
   ```bash
   mkdir -p ~/bin
   cp caffeine-fix ~/bin/
   cp caffeine-fix-indicator ~/bin/
   chmod +x ~/bin/caffeine-fix
   chmod +x ~/bin/caffeine-fix-indicator
   ```

2. **Ensure `~/bin` is in your PATH:**

   On Ubuntu/Debian, `~/.profile` adds `~/bin` to your PATH automatically if it exists
   (log out and back in after creating it). Otherwise add it to your shell config:
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
   ```

3. **Install the tray icons:**
   ```bash
   ./install-icons.sh
   ```

## Usage

### System Tray Indicator
Start the indicator:
```bash
caffeine-fix-indicator
```

The indicator will appear in your system tray. Click on it to:
- View current status
- Toggle caffeine on/off
- Quit the application

### Command Line
```bash
# Toggle caffeine on/off
caffeine-fix toggle

# Enable caffeine
caffeine-fix on

# Disable caffeine
caffeine-fix off

# Check status
caffeine-fix status
```

## Autostart

To start the indicator automatically on login:

1. **Using GNOME Settings:**
   - Open "Startup Applications"
   - Add a new entry:
     - Name: `Caffeine Fix`
     - Command: `/home/YOUR_USERNAME/bin/caffeine-fix-indicator`
     - Comment: `Prevent system sleep`

2. **Manual Desktop Entry:**
   ```bash
   mkdir -p ~/.config/autostart
   cat > ~/.config/autostart/caffeine-fix-indicator.desktop << EOF
   [Desktop Entry]
   Type=Application
   Name=Caffeine Fix Indicator
   Comment=Prevent system sleep
   Exec=$HOME/bin/caffeine-fix-indicator
   Icon=caffeine-inactive
   Terminal=false
   Categories=Utility;
   X-GNOME-Autostart-enabled=true
   EOF
   ```

## How It Works

This tool uses GNOME's built-in `gnome-session-inhibit` command to prevent the system from entering idle mode. Unlike older caffeine tools that relied on X11-specific features, this works natively with Wayland by using the proper GNOME session APIs.

When activated:
- The system will not automatically lock the screen
- The display will not turn off due to inactivity
- The system will not suspend/sleep automatically

Normal sleep prevention still works (like closing the laptop lid or manual suspension).

## Troubleshooting

### Indicator doesn't show in system tray
- Ensure you have `gir1.2-ayatanaappindicatorglib-2.0` installed (Ubuntu/Debian)
- On GNOME, make sure the AppIndicator extension is enabled (`ubuntu-appindicators@ubuntu.com` on Ubuntu)
- Try restarting your session after installation
- Check if your desktop environment supports system tray icons

### Caffeine doesn't prevent sleep
- Verify `gnome-session-inhibit` is installed
- Check if the process is running: `pgrep -f gnome-session-inhibit`
- Some system policies may override inhibit requests

### Icons not showing
- Run the icon installation script: `./install-icons.sh`
- Update icon cache: `gtk-update-icon-cache ~/.local/share/icons/hicolor`

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## License

MIT License - See LICENSE file for details

## Acknowledgments

- Inspired by the original Caffeine application for X11
- Uses GNOME Session Manager APIs for Wayland compatibility
- CLI status uses the coffee cup (☕) and sleeping (💤) emoji

## Alternatives

If this doesn't work for your setup, consider:
- [Caffeine](https://launchpad.net/caffeine) - Original X11 version
- [Caffeine-ng](https://codeberg.org/WhyNotHugo/caffeine-ng) - Next-generation caffeine
- Manual use of `gnome-session-inhibit` or `systemd-inhibit`
