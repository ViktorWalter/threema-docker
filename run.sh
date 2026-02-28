#/bin/bash
xhost +local:

export GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d \')
export ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d \')
export XDG_DATA_DIRS=/home/flatpakuser/.local/share:/usr/local/share:/usr/share
export QT_QPA_PLATFORMTHEME=gtk2
export QT_STYLE_OVERRIDE=$(kreadconfig5 --file kdeglobals --group KDE --key widgetStyle)

docker run \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY="$XAUTHORITY" \
  -e DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
  -v /run/user/1000/pulse:/run/user/1000/pulse \
  -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
  -v "$XAUTHORITY:$XAUTHORITY:ro" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp:/tmp \
  -v ./data/local:/home/flatpakuser/.local \
  -v ./data/cache:/home/flatpakuser/.cache \
  -v ./data/config:/home/flatpakuser/.config \
  -v ./data/var:/home/flatpakuser/.var \
  -v /home/${USER}:/home/flatpakuser/host_home \
  -v /usr/share/themes:/usr/share/themes:ro \
  -v /usr/share/icons:/usr/share/icons:ro \
  -v $HOME/.themes:/home/flatpakuser/.themes:ro \
  -v $HOME/.icons:/home/flatpakuser/.icons:ro \
  -v $HOME/.config/gtk-3.0:/home/flatpakuser/.config/gtk-3.0:ro \
  -v $HOME/.config/kdeglobals:/home/flatpakuser/.config/kdeglobals:ro \
  --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --cap-add=SYS_ADMIN \
    --device /dev/fuse \
    --device /dev/snd \
    --group-add audio \
    threema

 # The line "-v /home/${USER}:/home/flatpakuser/host_home" allows the user have access to host files - remove if undesirable
