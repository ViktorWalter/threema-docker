FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive



RUN set -eux; \
    existing_user="$(getent passwd 1000 | cut -d: -f1)"; \
    existing_group="$(id -gn 1000)"; \
    usermod -l flatpakuser "$existing_user"; \
    usermod -d /home/flatpakuser -m flatpakuser && \
    groupmod -n flatpakuser "$existing_group";

# Give them a home directory for Flatpak installs
ENV HOME=/home/flatpakuser
WORKDIR /home/flatpakuser

# Allow Flatpak user installs

# Core dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ca-certificates \
    gnupg \
    curl \
    dbus \
    dbus-user-session \
    fuse \
    gosu \
    gnome-keyring \
    libsecret-1-0 \
    && rm -rf /var/lib/apt/lists/*

# Add Flatpak stable PPA
RUN add-apt-repository ppa:flatpak/stable

# Install Flatpak 1.16.x (pin to 1.16)
RUN apt-get update && \
    apt-get install -y flatpak=1.16.* && \
    rm -rf /var/lib/apt/lists/*

# Ensure runtime dirs exist
RUN mkdir -p /run/dbus && chmod 755 /run/dbus

RUN flatpak install -y  --from \
    https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref && \
    flatpak override  \
    ch.threema.threema-desktop --filesystem=host


ENTRYPOINT ["/home/flatpakuser/entrypoint.sh"]

# Default shell
CMD ["/bin/bash"]
