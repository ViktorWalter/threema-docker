#/bin/bash
xhost +local:

docker run -it \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp:/tmp \
  -v ./data:/home/flatpakuser/.var \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --cap-add=SYS_ADMIN \
  --device /dev/fuse \
  threema
