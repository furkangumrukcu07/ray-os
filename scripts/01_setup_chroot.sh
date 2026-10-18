#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "=== [1/4] Setting up Debian Bookworm repositories & firmware ==="

cat << 'EOF' > /etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF

apt-get update

# Install Linux Kernel and complete non-free firmware for broad hardware compatibility
apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    linux-headers-amd64 \
    firmware-linux \
    firmware-linux-nonfree \
    firmware-misc-nonfree \
    firmware-realtek \
    firmware-atheros \
    firmware-iwlwifi \
    intel-microcode \
    amd64-microcode \
    live-boot \
    systemd-sysv

# Essential networking & audio stack
apt-get install -y --no-install-recommends \
    network-manager \
    network-manager-gnome \
    wireless-tools \
    wpasupplicant \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    pavucontrol \
    sudo \
    curl \
    wget \
    git \
    unzip \
    ca-certificates \
    pciutils \
    usbutils \
    macfanctld || true

# Setup live user
if ! id "rayos" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo,audio,video,netdev,plugdev rayos
    echo "rayos:rayos" | chpasswd
    echo "rayos ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rayos
    chmod 0440 /etc/sudoers.d/rayos
fi

echo "=== Step 1 Complete ==="
