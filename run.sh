#/bin/bash
xhost +local:

docker run \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY="$XAUTHORITY" \
  -e DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
  -v "$XAUTHORITY:$XAUTHORITY:ro" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp:/tmp \
  -v ./data/local:/home/flatpakuser/.local \
  -v ./data/cache:/home/flatpakuser/.cache \
  -v ./data/config:/home/flatpakuser/.config \
  -v ./data/var:/home/flatpakuser/.var \
  -v /home/${USER}:/home/flatpakuser/host_home \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --cap-add=SYS_ADMIN \
  --device /dev/fuse \
  threema

 # The line "-v /home/${USER}:/home/flatpakuser/host_home" allows the user have access to host files - remove if undesirable
