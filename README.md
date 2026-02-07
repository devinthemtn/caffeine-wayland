# Caffeine Fix for Wayland

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
- Coffee cup icon that changes based on active/inactive status
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
- **GTK 3** - For the system tray interface
- **AyatanaAppIndicator3** - For system tray support
- **notify-send** - For desktop notifications (optional)

### Ubuntu/Debian
```bash
sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-ayatanaappindicator3-0.1 gnome-session libnotify-bin
```

### Fedora
```bash
sudo dnf install python3-gobject gtk3 libayatana-appindicator-gtk3 gnome-session libnotify
```

### Arch Linux
```bash
sudo pacman -S python-gobject gtk3 libayatana-appindicator gnome-session libnotify
```

## Installation

### Automated Installation
```bash
./install.sh
```

This will:
- Copy scripts to `~/.local/bin/`
- Set executable permissions
- Create desktop entry for autostart (optional)
- Install tray icons

### Manual Installation

1. **Copy the scripts:**
   ```bash
   mkdir -p ~/.local/bin
   cp caffeine-fix ~/.local/bin/
   cp caffeine-fix-indicator ~/.local/bin/
   chmod +x ~/.local/bin/caffeine-fix
   chmod +x ~/.local/bin/caffeine-fix-indicator
   ```

2. **Ensure `~/.local/bin` is in your PATH:**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Install icons (optional):**
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
     - Command: `/home/YOUR_USERNAME/.local/bin/caffeine-fix-indicator`
     - Comment: `Prevent system sleep`

2. **Manual Desktop Entry:**
   ```bash
   mkdir -p ~/.config/autostart
   cat > ~/.config/autostart/caffeine-fix.desktop << 'EOF'
   [Desktop Entry]
   Type=Application
   Name=Caffeine Fix
   Comment=Prevent system sleep
   Exec=caffeine-fix-indicator
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
- Ensure you have `gir1.2-ayatanaappindicator3-0.1` installed
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
- Icons: Coffee cup emoji (☕) and sleeping emoji (💤)

## Alternatives

If this doesn't work for your setup, consider:
- [Caffeine](https://launchpad.net/caffeine) - Original X11 version
- [Caffeine-ng](https://codeberg.org/WhyNotHugo/caffeine-ng) - Next-generation caffeine
- Manual use of `gnome-session-inhibit` or `systemd-inhibit`
