FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Create a normal user
RUN useradd -m -u 1001 flatpakuser

# Give them a home directory for Flatpak installs
ENV HOME=/home/flatpakuser
WORKDIR /home/flatpakuser

# Allow Flatpak user installs
RUN chown -R flatpakuser:flatpakuser /home/flatpakuser

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
    && rm -rf /var/lib/apt/lists/*

# Add Flatpak stable PPA
RUN add-apt-repository ppa:flatpak/stable

# Install Flatpak 1.16.x (pin to 1.16)
RUN apt-get update && \
    apt-get install -y flatpak=1.16.* && \
    rm -rf /var/lib/apt/lists/*

# Verify version at build time
RUN flatpak --version

# Optional: add Flathub
RUN flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo
#RUN flatpak install org.freedesktop.Platform/x86_64/24.08
RUN flatpak install --user -y --from \
    https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref && \
    flatpak override \
    ch.threema.threema-desktop --filesystem=host

COPY entrypoint.sh /home/flatpakuser/entrypoint.sh

# Ensure runtime dirs exist
RUN mkdir -p /run/dbus && chmod 755 /run/dbus

RUN chown -R flatpakuser:flatpakuser /home/flatpakuser

# USER flatpakuser

ENTRYPOINT ["/home/flatpakuser/entrypoint.sh"]

# Default shell
CMD ["/bin/bash"]
