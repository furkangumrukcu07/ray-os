# 🌟 Ray OS 1.0 (Lumina) - Frosted Glass Edition

> **Debian 12 (Bookworm) tabanlı, GNOME Frosted Glass (Buzlu Cam / Akrilik) arayüzüne ve Ray IPTV Player logosuna sahip modern 64-bit işletim sistemi.**

---

## 🎨 Ray OS Özellikleri

* **Gerçek Buzlu Cam (Frosted Glass) Arayüz:**
  * `blur-my-shell` çekirdeği ile üst durum çubuğu, kilit ekranı, uygulama menüsü ve pencereler şeffaf ve arkası gerçek zamanlı bulanıklaştırılmış (acrylic blur) çalışır.
  * `dash-to-dock` ile ekranın altında yüzen, yarı saydam cam dock.
  * **Orchis Dark Glass** GTK teması + **Tela Circle** cam simge seti.
* **Ray Markalaması (Branding):**
  * Ray IPTV Player'ın 1024x1024 orijinal logosu açılış ekranı (Plymouth), GRUB önyükleyici, Calamares kurulum sihirbazı ve sistem ikonlarında kullanıldı.
  * 2560x1440 yüksek çözünürlüklü Ray cam kırılmalı (glassmorphism & light glass) duvar kağıtları.
  * `/etc/os-release`: `Ray OS 1.0 Lumina`.
  * Terminalde neon cam mavisi Ray OS logolu **Fastfetch** karşılama ekranı.
* **Geniş Donanım Desteği:**
  * Debian 12 Bookworm + `firmware-linux-nonfree` (Intel, AMD, Nvidia, Broadcom, Realtek Wi-Fi/Bluetooth tak-çalıştır tanınır).
* **Calamares Kurulum Sihirbazı:**
  * USB'den canlı açıldığında masaüstündeki "Install Ray OS" simgesiyle Türkçe ve resimli adım adım kolay kurulum.

---

## 🚀 ISO Dosyasını Derleme Yolları

Linux ISO'su derlemek Linux araçları (`debootstrap`, `xorriso`, `mksquashfs`) gerektirir. Mac üzerinde olduğunuz için **2 kolay yöntem** hazırladık:

### 1. Yöntem: GitHub Actions İle Bulutta Derleme (En Kolay & Ücretsiz)
Bilgisayarınıza hiçbir şey kurmadan, bu klasörü GitHub'a yükleyerek ISO'nuzu derleyebilirsiniz:

1. Bu `RayOS_Builder` klasörünü bir Git deposu olarak başlatıp GitHub'da yeni bir depoya yükleyin (Public veya Private):
   ```bash
   cd /Users/macbook/Desktop/RayOS_Builder
   git init
   git add .
   git commit -m "Ray OS 1.0 Initial Setup"
   git branch -M main
   git remote add origin https://github.com/KULLANICI_ADINIZ/ray-os.git
   git push -u origin main
   ```
2. GitHub'da deponuza gidin ve **Actions** sekmesine tıklayın.
3. Soldan **"Build Ray OS ISO"** seçeneğine gelip **"Run workflow"** butonuna basın.
4. GitHub sunucuları ~20 dakika içinde ISO'yu derleyip doğrudan indirilebilir **`RayOS-1.0-Lumina-x86_64.iso`** linki sunacaktır!

---

### 2. Yöntem: Yerel Linux Makinesinde veya Sanal Makinede Derleme
Eğer elinizin altında bir Ubuntu/Debian bilgisayar veya sanal makine varsa:

```bash
cd RayOS_Builder
sudo ./build_iso.sh
```

İşlem tamamlandığında `RayOS_Builder/output/` klasöründe hazır ISO dosyanız oluşacaktır.

---

## 💾 USB Belleğe Yazdırma
Oluşan `RayOS-1.0-Lumina-x86_64.iso` dosyasını:
* **BalenaEtcher** (Mac/Windows/Linux) veya
* **Rufus** (Windows - GPT / UEFI veya MBR / BIOS seçeneğiyle)
kullanarak bir USB belleğe yazdırıp istediğiniz bilgisayarda başlatabilirsiniz.
