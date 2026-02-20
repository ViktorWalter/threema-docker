#!/bin/bash
set -e

chmod +x ./run.sh
chmod +x ./entrypoint.sh
chmod +x ./build.sh

./build.sh

id=$(docker create threema)
docker cp -L $id:/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/ch.threema.threema-desktop.svg ./icon.svg
docker rm -v $id

APP_NAME="Threema Desktop"
DESKTOP_FILE_NAME="threema-desktop.desktop"

# Resolve the directory where this script (and run.sh) lives

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUN_SCRIPT="$APP_DIR/run.sh"
ICON_FILE="$APP_DIR/icon.svg"   # Optional

TARGET_DIR="$HOME/.local/share/applications"
TARGET_FILE="$TARGET_DIR/$DESKTOP_FILE_NAME"

echo "Installing launcher to: $TARGET_FILE"

mkdir -p "$TARGET_DIR"

# Ensure run script is executable

chmod +x "$RUN_SCRIPT"

# Create the .desktop file

cat > "$TARGET_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=Launch $APP_NAME (Docker)
Exec=$RUN_SCRIPT
Path=$APP_DIR
Terminal=false
Categories=Utility;
EOF

# Add icon if present

if [ -f "$ICON_FILE" ]; then
echo "Icon detected — adding to launcher"
echo "Icon=$ICON_FILE" >> "$TARGET_FILE"
fi

chmod +x "$TARGET_FILE"

# Update desktop database if available (not required, but nice)

if command -v update-desktop-database >/dev/null 2>&1; then
update-desktop-database "$TARGET_DIR" || true
fi

echo "Installation complete."
echo "You may need to log out/in once for the icon to appear in some desktops."
