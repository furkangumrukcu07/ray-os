#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "=== [2/4] Installing GNOME Shell and Frosted Glass Extension Stack ==="

apt-get update

# Install GNOME Minimal Core, GDM3 Display Manager, and essential tools
apt-get install -y --no-install-recommends \
    gnome-core \
    gdm3 \
    gnome-terminal \
    gnome-tweaks \
    gnome-shell-extension-manager \
    gnome-shell-extensions \
    nautilus \
    eog \
    gedit \
    evince \
    file-roller \
    gnome-system-monitor \
    gnome-disk-utility \
    vlc \
    transmission-gtk \
    fonts-inter \
    fonts-jetbrains-mono \
    calamares \
    calamares-settings-debian \
    gparted \
    dconf-cli \
    plymouth \
    plymouth-themes \
    gpg

# Setup Official Opera Browser Repository & Install Latest Opera Stable
echo "Adding Opera official repository..."
mkdir -p /usr/share/keyrings
wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | tee /usr/share/keyrings/opera-browser.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera-stable.list
apt-get update
# Pre-seed debconf so Opera doesn't block with interactive debconf prompt during apt install
echo "opera-stable opera-stable/add-deb-source boolean false" | debconf-set-selections
apt-get install -y opera-stable

# Set Opera as default web browser
update-alternatives --set x-www-browser /usr/bin/opera || true
xdg-settings set default-web-browser opera.desktop 2>/dev/null || true

# Configure GDM3 Auto-login for Live session
mkdir -p /etc/gdm3
cat << 'EOF' > /etc/gdm3/daemon.conf
[daemon]
AutomaticLoginEnable = true
AutomaticLogin = rayos
WaylandEnable=true
EOF

# Install Blur My Shell extension (Frosted Glass core engine)
echo "Installing Blur My Shell Extension..."
mkdir -p /usr/share/gnome-shell/extensions
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download latest release of blur-my-shell
curl -s https://api.github.com/repos/aunetx/blur-my-shell/releases/latest \
  | grep "browser_download_url.*zip" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -qi - -O blur-my-shell.zip || true

if [ -f blur-my-shell.zip ]; then
    mkdir -p /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
    unzip -q blur-my-shell.zip -d /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/
fi

# Download Dash to Dock extension
echo "Installing Dash to Dock Extension..."
curl -s https://api.github.com/repos/micheleg/dash-to-dock/releases/latest \
  | grep "browser_download_url.*zip" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -qi - -O dash-to-dock.zip || true

if [ -f dash-to-dock.zip ]; then
    mkdir -p /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
    unzip -q dash-to-dock.zip -d /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
fi

# Install Orchis Glass / Dark GTK theme
echo "Installing Orchis Dark GTK Theme..."
git clone --depth=1 https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh -t default -c dark -s standard --round 5px || true
cd ..

# Install Tela Circle Icon Theme
echo "Installing Tela Circle Icon Theme..."
git clone --depth=1 https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
./install.sh -c dark || true
cd ..

# Clean up temporary build artifacts
cd /
rm -rf "$TEMP_DIR"

echo "=== Step 2 Complete ==="
