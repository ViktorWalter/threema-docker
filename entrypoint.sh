#!/usr/bin/env bash
set -e

# D-Bus requires a machine-id or it will fail silently
if [ ! -f /etc/machine-id ]; then
    dbus-uuidgen > /etc/machine-id
fi

# Start the system bus if not already running
if ! pgrep -x dbus-daemon > /dev/null; then
    echo "Starting system D-Bus..."
    dbus-daemon --system --fork --nopidfile
else
    echo "D-Bus appears to be running."
fi

# Fix XDG paths for Flatpak user installs
export XDG_DATA_DIRS="/home/flatpakuser/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"


# Export bus address so Flatpak can find it
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

echo "Dropping privileges to flatpakuser"
exec gosu flatpakuser dbus-run-session -- /usr/bin/flatpak run ch.threema.threema-desktop
