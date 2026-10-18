#!/bin/bash
set -e

echo "=== [3/4] Applying Ray OS Branding, Wallpapers, and Frosted Glass Defaults ==="

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. System Branding
cp -f "$BUILD_DIR/config/os-release" /etc/os-release
cp -f "$BUILD_DIR/config/lsb-release" /etc/lsb-release
cp -f "$BUILD_DIR/config/issue" /etc/issue
cp -f "$BUILD_DIR/config/issue.net" /etc/issue.net

# Privacy Policy Documentation
mkdir -p /usr/share/doc/rayos
cp -f "$BUILD_DIR/PRIVACY_POLICY.md" /usr/share/doc/rayos/PRIVACY_POLICY.md
chmod 644 /usr/share/doc/rayos/PRIVACY_POLICY.md

# 2. Wallpapers
mkdir -p /usr/share/backgrounds/rayos
cp -rf "$BUILD_DIR/assets/wallpapers/"* /usr/share/backgrounds/rayos/
chmod 644 /usr/share/backgrounds/rayos/*

# 3. Ray OS Logo Icons
mkdir -p /usr/share/icons/hicolor/512x512/apps
mkdir -p /usr/share/icons/hicolor/256x256/apps
mkdir -p /usr/share/icons/hicolor/128x128/apps
mkdir -p /usr/share/pixmaps

cp -f "$BUILD_DIR/assets/logo/ray_logo_512.png" /usr/share/icons/hicolor/512x512/apps/ray-os-logo.png
cp -f "$BUILD_DIR/assets/logo/ray_logo_256.png" /usr/share/icons/hicolor/256x256/apps/ray-os-logo.png
cp -f "$BUILD_DIR/assets/logo/ray_logo_128.png" /usr/share/icons/hicolor/128x128/apps/ray-os-logo.png
cp -f "$BUILD_DIR/assets/logo/ray_logo_128.png" /usr/share/pixmaps/ray-os-logo.png

# 4. Plymouth Splash Theme
mkdir -p /usr/share/plymouth/themes/ray-splash
cp -rf "$BUILD_DIR/plymouth/ray-splash/"* /usr/share/plymouth/themes/ray-splash/
if command -v plymouth-set-default-theme &>/dev/null; then
    plymouth-set-default-theme -R ray-splash || true
fi

# 5. GRUB Theme
mkdir -p /boot/grub/themes/ray-glass
cp -rf "$BUILD_DIR/grub/ray-glass/"* /boot/grub/themes/ray-glass/
cat << 'EOF' >> /etc/default/grub
GRUB_THEME="/boot/grub/themes/ray-glass/theme.txt"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
EOF

# 6. Calamares Installer Branding
mkdir -p /etc/calamares/branding/rayos
cp -rf "$BUILD_DIR/calamares/branding/rayos/"* /etc/calamares/branding/rayos/
cp -f "$BUILD_DIR/calamares/settings.conf" /etc/calamares/settings.conf

# 7. GNOME dconf Glass Defaults
mkdir -p /etc/dconf/profile
cat << 'EOF' > /etc/dconf/profile/user
user-db:user
system-db:local
EOF

mkdir -p /etc/dconf/db/local.d
cp -f "$BUILD_DIR/gnome/dconf/00-rayos-glass" /etc/dconf/db/local.d/00-rayos-glass
dconf update || true

# 8. Live User Desktop Shortcut: Install Ray OS
mkdir -p /home/rayos/Desktop
cat << 'EOF' > /home/rayos/Desktop/calamares.desktop
[Desktop Entry]
Type=Application
Version=1.0
Name=Install Ray OS
GenericName=Live Installer
Comment=Install Ray OS 1.0 Lumina to your hard drive or SSD
Exec=sudo -E calamares
Icon=ray-os-logo
Terminal=false
StartupNotify=true
Categories=System;
EOF
chmod +x /home/rayos/Desktop/calamares.desktop
cp -f "$BUILD_DIR/PRIVACY_POLICY.md" /home/rayos/Desktop/Gizlilik_Politikasi.md
chown -R rayos:rayos /home/rayos/Desktop

# 9. Fastfetch Custom Config
mkdir -p /etc/fastfetch
cp -f "$BUILD_DIR/config/fastfetch/config.jsonc" /etc/fastfetch/config.jsonc
echo "fastfetch" >> /home/rayos/.bashrc
echo "fastfetch" >> /root/.bashrc

echo "=== Step 3 Complete ==="
