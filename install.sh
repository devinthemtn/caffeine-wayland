#!/bin/bash
# Installation script for Caffeine Fix

set -e

echo "Installing Caffeine Fix for Wayland..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installation directories
BIN_DIR="$HOME/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

# Create directories
mkdir -p "$BIN_DIR"
echo -e "${GREEN}✓${NC} Created $BIN_DIR"

# Copy scripts
cp caffeine-fix "$BIN_DIR/"
cp caffeine-fix-indicator "$BIN_DIR/"
chmod +x "$BIN_DIR/caffeine-fix"
chmod +x "$BIN_DIR/caffeine-fix-indicator"
echo -e "${GREEN}✓${NC} Installed caffeine-fix and caffeine-fix-indicator to $BIN_DIR"

# Install tray icons
./install-icons.sh

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}⚠${NC}  Warning: $BIN_DIR is not in your PATH"
    echo "   On Ubuntu/Debian, log out and back in (~/.profile adds ~/bin automatically)."
    echo "   Otherwise add this line to your ~/.bashrc or ~/.zshrc:"
    echo "   export PATH=\"\$HOME/bin:\$PATH\""
fi

# Ask about autostart
echo ""
read -p "Do you want to enable autostart on login? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_DIR/caffeine-fix-indicator.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Caffeine Fix Indicator
Comment=Prevent system sleep
Exec=$BIN_DIR/caffeine-fix-indicator
Icon=caffeine-inactive
Terminal=false
Categories=Utility;
X-GNOME-Autostart-enabled=true
EOF
    echo -e "${GREEN}✓${NC} Created autostart entry"
fi

# Check dependencies
echo ""
echo "Checking dependencies..."

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 found"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1 not found"
        return 1
    fi
}

ALL_DEPS_OK=true

check_command "python3" || ALL_DEPS_OK=false
check_command "gnome-session-inhibit" || ALL_DEPS_OK=false
check_command "notify-send" || echo -e "${YELLOW}⚠${NC}  notify-send not found (optional)"

# Check Python modules
echo ""
echo "Checking Python dependencies..."
python3 -c "import gi" 2>/dev/null && echo -e "${GREEN}✓${NC} Python GObject bindings found" || { echo -e "${YELLOW}✗${NC} Python GObject bindings not found"; ALL_DEPS_OK=false; }
python3 -c "import gi; gi.require_version('AyatanaAppIndicatorGlib', '2.0')" 2>/dev/null && echo -e "${GREEN}✓${NC} AyatanaAppIndicatorGlib found" || { echo -e "${YELLOW}✗${NC} AyatanaAppIndicatorGlib not found"; ALL_DEPS_OK=false; }

if [ "$ALL_DEPS_OK" = false ]; then
    echo ""
    echo -e "${YELLOW}⚠${NC}  Some dependencies are missing. Install them with:"
    echo ""
    if command -v apt &> /dev/null; then
        echo "  sudo apt install python3-gi gir1.2-ayatanaappindicatorglib-2.0 gnome-session libnotify-bin"
    elif command -v dnf &> /dev/null; then
        echo "  sudo dnf install python3-gobject libayatana-appindicator-glib gnome-session libnotify"
    elif command -v pacman &> /dev/null; then
        echo "  sudo pacman -S python-gobject libayatana-appindicator-glib gnome-session libnotify"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  Start indicator:  caffeine-fix-indicator"
echo "  CLI:              caffeine-fix toggle|on|off|status"
echo ""
echo "To test the installation:"
echo "  caffeine-fix-indicator &"
