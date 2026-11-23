#!/bin/bash
# Install Caffeine Fix tray icons into the user's hicolor icon theme

set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_DIR="$HOME/.local/share/icons/hicolor"
APPS_DIR="$ICON_DIR/scalable/apps"

mkdir -p "$APPS_DIR"
cp "$SCRIPT_DIR/icons/caffeine-active.svg" "$APPS_DIR/"
cp "$SCRIPT_DIR/icons/caffeine-inactive.svg" "$APPS_DIR/"
echo -e "${GREEN}✓${NC} Installed icons to $APPS_DIR"

# Refresh the icon cache so the new icons are picked up
if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t "$ICON_DIR" &> /dev/null || true
    echo -e "${GREEN}✓${NC} Updated icon cache"
fi
