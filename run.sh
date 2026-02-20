#/bin/bash
xhost +local:

chmod +x ./entrypoint.sh

docker run -it \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp:/tmp \
  -v ./data/local:/home/flatpakuser/.local \
  -v ./data/cache:/home/flatpakuser/.cache \
  -v ./data/config:/home/flatpakuser/.config \
  -v ./data/var:/home/flatpakuser/.var \
  -v ./entrypoint.sh:/home/flatpakuser/entrypoint.sh \
  -v /home/${USER}:/home/flatpakuser/host_home \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --cap-add=SYS_ADMIN \
  --device /dev/fuse \
  threema

 # The line "-v /home/${USER}:/home/flatpakuser/host_home" allows the user have access to host files - remove if undesirable
