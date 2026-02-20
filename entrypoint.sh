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



# Export bus address so Flatpak can find it
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket
# Create user runtime dir (normally done by logind)
mkdir -p /run/user/1000
chown flatpakuser:flatpakuser /run/user/1000
chmod 700 /run/user/1000

export XDG_RUNTIME_DIR=/run/user/1000

# Ensure expected home layout exists (important for bind mounts)
mkdir -p /home/flatpakuser/.local/share
mkdir -p /home/flatpakuser/.var
chown -R flatpakuser:flatpakuser /home/flatpakuser/.local /home/flatpakuser/.var

# Avoid recursive chown of large mounted homes; just ensure top-level ownership
if [ "$(stat -c %u /home/flatpakuser)" != "1000" ]; then
    chown flatpakuser:flatpakuser /home/flatpakuser
fi

# Fix XDG paths for Flatpak user installs
export XDG_DATA_DIRS="/home/flatpakuser/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

echo "Dropping privileges to flatpakuser"
exec gosu flatpakuser dbus-run-session -- bash -c '
set -e

/bin/bash
'
