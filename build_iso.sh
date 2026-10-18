#!/usr/bin/env bash
# ==============================================================================
# Ray OS 1.0 Lumina - Official ISO Master Builder
# Debian 12 (Bookworm) 64-bit with GNOME Frosted Glass Interface
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Error: This script must be run as root (sudo ./build_iso.sh)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_NAME="RayOS-1.0-Lumina-x86_64"
OUTPUT_DIR="${SCRIPT_DIR}/output"
WORK_DIR="/tmp/rayos_build"
CHROOT_DIR="${WORK_DIR}/chroot"
IMAGE_DIR="${WORK_DIR}/image"

echo "=========================================================="
echo "          Ray OS 1.0 (Lumina) ISO Build Process           "
echo "=========================================================="

# 1. Install Host Dependencies
echo "[+] Step 1: Checking and installing host dependencies..."
apt-get update -qq
apt-get install -y --no-install-recommends \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    wget \
    curl

# 2. Prepare Work Directory
rm -rf "$WORK_DIR"
mkdir -p "$CHROOT_DIR"
mkdir -p "$IMAGE_DIR/live"
mkdir -p "$IMAGE_DIR/boot/grub"
mkdir -p "$IMAGE_DIR/EFI/BOOT"
mkdir -p "$OUTPUT_DIR"

# 3. Bootstrap Base Debian 12 Bookworm
echo "[+] Step 2: Bootstrapping Debian 12 (Bookworm) base system..."
debootstrap --arch=amd64 --variant=minbase bookworm "$CHROOT_DIR" http://deb.debian.org/debian

# 4. Bind System Mounts & Project Files
echo "[+] Step 3: Binding mounts for chroot environment..."
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

cleanup() {
    echo "[!] Cleaning up mounts..."
    umount -lf "$CHROOT_DIR/dev/pts" 2>/dev/null || true
    umount -lf "$CHROOT_DIR/dev" 2>/dev/null || true
    umount -lf "$CHROOT_DIR/proc" 2>/dev/null || true
    umount -lf "$CHROOT_DIR/sys" 2>/dev/null || true
    umount -lf "$CHROOT_DIR/builder" 2>/dev/null || true
}
trap cleanup EXIT

mkdir -p "$CHROOT_DIR/builder"
mount --bind "$SCRIPT_DIR" "$CHROOT_DIR/builder"

# 5. Run Customization Scripts in Chroot
echo "[+] Step 4: Executing Ray OS configuration scripts inside chroot..."
chroot "$CHROOT_DIR" /bin/bash /builder/scripts/01_setup_chroot.sh
chroot "$CHROOT_DIR" /bin/bash /builder/scripts/02_install_gnome_glass.sh
chroot "$CHROOT_DIR" /bin/bash /builder/scripts/03_apply_branding.sh

# 6. Extract Kernel & Initrd for Bootloader
echo "[+] Step 5: Extracting kernel and initramfs..."
vmlinuz=$(ls -1 "$CHROOT_DIR/boot"/vmlinuz-* | sort -V | tail -n 1)
initrd=$(ls -1 "$CHROOT_DIR/boot"/initrd.img-* | sort -V | tail -n 1)

cp "$vmlinuz" "$IMAGE_DIR/live/vmlinuz"
cp "$initrd" "$IMAGE_DIR/live/initrd.img"

# 7. Clean up Chroot before SquashFS
echo "[+] Step 6: Cleaning chroot cache..."
chroot "$CHROOT_DIR" apt-get clean
chroot "$CHROOT_DIR" rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
umount -lf "$CHROOT_DIR/builder"

# 8. Create SquashFS Filesystem
echo "[+] Step 7: Compressing system into SquashFS (XZ high compression)..."
mksquashfs "$CHROOT_DIR" "$IMAGE_DIR/live/filesystem.squashfs" -comp xz -b 1048576 -noappend

# 9. Configure GRUB Bootloader for Live Boot
echo "[+] Step 8: Configuring UEFI & BIOS GRUB menus..."
cat << 'EOF' > "$IMAGE_DIR/boot/grub/grub.cfg"
set default="0"
set timeout=5

insmod font
if loadfont /boot/grub/font.pf2 ; then
    insmod gfxterm
    set gfxmode=auto
    terminal_output gfxterm
fi

menuentry "Start Ray OS 1.0 Lumina (Live)" {
    linux /live/vmlinuz boot=live quiet splash components
    initrd /live/initrd.img
}

menuentry "Start Ray OS 1.0 (Safe Graphics / Nomodeset)" {
    linux /live/vmlinuz boot=live nomodeset components
    initrd /live/initrd.img
}

menuentry "Check System Memory (Memtest86+)" {
    linux16 /live/memtest
}
EOF

# 10. Generate EFI Boot Image
echo "[+] Step 9: Creating EFI system partition..."
grub-mkstandalone \
    --format=x86_64-efi \
    --output="$IMAGE_DIR/EFI/BOOT/bootx64.efi" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$IMAGE_DIR/boot/grub/grub.cfg"

# Create efiboot.img for UEFI El Torito
dd if=/dev/zero of="$IMAGE_DIR/boot/grub/efiboot.img" bs=1M count=20
mkfs.vfat "$IMAGE_DIR/boot/grub/efiboot.img"
mmd -i "$IMAGE_DIR/boot/grub/efiboot.img" ::/EFI ::/EFI/BOOT
mcopy -i "$IMAGE_DIR/boot/grub/efiboot.img" "$IMAGE_DIR/EFI/BOOT/bootx64.efi" ::/EFI/BOOT/

# 11. Build Hybrid ISO (UEFI + Legacy BIOS)
echo "[+] Step 10: Generating hybrid bootable ISO with xorriso..."
ISO_PATH="${OUTPUT_DIR}/${DIST_NAME}.iso"

xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "RAYOS_LUMINA" \
    -eltorito-boot boot/grub/bios.img \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    --eltorito-catalog boot/grub/boot.cat \
    --grub2-boot-info \
    --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
    -eltorito-alt-boot \
    -e boot/grub/efiboot.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -output "$ISO_PATH" \
    "$IMAGE_DIR" 2>/dev/null || \
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "RAYOS_LUMINA" \
    -eltorito-alt-boot \
    -e boot/grub/efiboot.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -output "$ISO_PATH" \
    "$IMAGE_DIR"

# 12. Generate Checksum
cd "$OUTPUT_DIR"
sha256sum "${DIST_NAME}.iso" > "${DIST_NAME}.iso.sha256"

echo "=========================================================="
echo " [SUCCESS] Ray OS ISO successfully created!"
echo " ISO File: $ISO_PATH"
echo " SHA256  : $(cat "${DIST_NAME}.iso.sha256")"
echo "=========================================================="
