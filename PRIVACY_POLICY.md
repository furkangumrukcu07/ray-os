# Ray OS Gizlilik Politikası / Privacy Policy

**Son Güncelleme / Last Updated:** 18 Ekim 2026 / October 18, 2026  
**Sürüm / Version:** 1.0 (Lumina)  
**İşletim Sistemi / Operating System:** Ray OS (Debian 12 Bookworm Based)

---

## 🇹🇷 TÜRKÇE: Ray OS Gizlilik ve Veri Güvenliği Politikası

Ray OS ("İşletim Sistemi", "Biz", "Bizim") olarak, kullanıcılarımızın gizliliğine ve dijital egemenliğine en üst düzeyde saygı duyuyoruz. Ray OS, **"Önce Gizlilik" (Privacy by Default)** ve **"Sıfır Telemetri" (Zero Telemetry)** ilkeleri temel alınarak tasarlanmıştır.

Bu Gizlilik Politikası, Ray OS'u canlı oturumda (Live USB) veya bilgisayarınızın diskine kurarak kullandığınızda verilerinizin nasıl (ve neden) işlendiğini açıklar.

---

### 1. Temel Gizlilik İlkelerimiz
* **Sıfır Zorunlu Telemetri:** Ray OS, arka planda kullanım alışkanlıklarınızı, açtığınız pencereleri, tuş vuruşlarınızı veya kişisel dosyalarınızı takip eden herhangi bir casus yazılım, telemetri servisi veya reklam kimliği içermez.
* **Zorunlu Hesap Yoktur:** İşletim sistemini kurmak veya kullanmak için bir çevrim içi hesap açmanız, e-posta veya telefon numarası vermeniz gerekmez.
* **Verileriniz Sizin Cihazınızda Kalır:** Belgeleriniz, parolalarınız ve tüm kişisel verileriniz yalnızca yerel diskinizde saklanır; harici hiçbir sunucuya yüklenmez.

---

### 2. Toplanan ve İşlenen Bilgiler

#### A. Kurulum Sırasında (Calamares Installer)
Ray OS'u diskinize kurarken sizden şu bilgiler istenir:
* **Kullanıcı Adı ve Parola:** Bilgisayarınızda yerel bir kullanıcı ve `sudo` (yönetici) hesabı oluşturmak için kullanılır. Parolalarınız güçlü `SHA-512` tuzlama (salt) algoritmasıyla yerel olarak şifrelenir (`/etc/shadow`).
* **Bilgisayar Adı (Hostname):** Yerel ağda cihazınızı tanımlamak için yerel olarak atanır.
* **Bölge ve Saat Dilimi:** Sistem saatini ve klavye düzeninizi yerel olarak ayarlamak için kullanılır.
* **Disk Bölümlendirme:** Seçtiğiniz disk alanını biçimlendirip Ray OS'u kurmak için kullanılır.

> **Önemli:** Kurulum sihirbazı sırasında girilen hiçbir veri internet üzerinden harici bir sunucuya aktarılmaz. Kurulum tamamen yerel (offline) çalışabilir.

#### B. Sistem Güncellemeleri ve Paket Yöneticisi (APT)
* Sistem güncellemeleri, güvenlik yamaları ve yazılım yüklemeleri Debian'ın ve Ray OS'un resmi yansıları (mirrors) üzerinden gerçekleştirilir.
* Güncelleme sunucuları, standart web trafiğinde olduğu gibi yalnızca isteği karşılamak için geçici IP adresi ve indirilen paket bilgisine erişir. Bu bilgiler herhangi bir profil oluşturma veya kullanıcı kimliğiyle eşleştirme amacıyla kullanılmaz.

#### C. Donanım ve Sürücü Tanıma
* Ray OS, bilgisayarınızın ekran kartı, Wi-Fi, ses yongası ve işlemcisini tanımak için yerel çekirdek (`udev` / `pciutils`) modüllerini çalıştırır.
* Donanım bilgileri hiçbir şekilde internete raporlanmaz; yalnızca donanımın doğru çalışması için gereken sürücülerin (firmware) yerel olarak yüklenmesini sağlar.

---

### 3. Üçüncü Taraf Uygulamalar
Ray OS, Firefox ESR gibi açık kaynaklı üçüncü taraf uygulamalarla birlikte gelir:
* Web tarayıcıları ve üçüncü taraf programlar, kendi gizlilik politikalarına tabidir.
* Kullanıcılar istedikleri uygulamayı diledikleri zaman kaldırma veya yenilerini yükleme konusunda tam yetkiye (root yetkisi) sahiptir.

---

### 4. Açık Kaynak Şeffaflığı
Ray OS, Debian GNU/Linux temeli ve açık kaynak lisansları (GPL, MIT, Apache) üzerine inşa edilmiştir. Tüm yapılandırma dosyaları, derleme betikleri (`build_iso.sh`) ve masaüstü bileşenleri bağımsız güvenlik araştırmacıları ve kullanıcılar tarafından kaynak kod düzeyinde incelenebilir ve denetlenebilir.

---

### 5. Haklarınız (KVKK & GDPR Uyumluluğu)
Ray OS merkezi bir kullanıcı veritabanı tutmadığı için verilerinizin tek sahibi sizsiniz:
* Verilerinizi silmek için diskinizi biçimlendirmeniz veya dosyalarınızı silmeniz yeterlidir.
* Takip edilmez, profillenmez ve ticari amaçla hedeflenmezsiniz.

---

### 6. İletişim
Gizlilik politikamızla ilgili soru ve geri bildirimleriniz için:
* **E-posta:** privacy@rayplayer.app
* **Web Sitesi:** https://rayplayer.app

---
---

## 🇬🇧 ENGLISH: Ray OS Privacy & Data Protection Policy

At Ray OS ("Operating System", "we", "our"), we strongly respect our users' privacy and digital sovereignty. Ray OS is designed with **"Privacy by Default"** and **"Zero Telemetry"** principles at its core.

This Privacy Policy explains how information is handled when you run Ray OS via Live USB or install it on your computer.

---

### 1. Core Principles
* **Zero Mandatory Telemetry:** Ray OS does not include spyware, background user tracking, keyloggers, or advertising IDs.
* **No Cloud Account Required:** You are never required to register an online account, provide an email, or link a phone number to use the system.
* **Local Data Sovereignty:** Your documents, passwords, and personal files remain solely on your local device.

---

### 2. Information Handled

#### A. During Installation (Calamares Installer)
When installing Ray OS to your hard drive or SSD:
* **Username & Password:** Used solely to create local user and administrative accounts. Passwords are encrypted locally with SHA-512.
* **Hostname & Timezone:** Used to set local network identification and system clock.
* **Disk Partitioning:** Used solely to prepare the selected partition for installation.
* *No installation data is transmitted to external servers.*

#### B. Software Updates (APT)
* Package downloads and security updates connect directly to official Debian and Ray OS mirrors.
* Standard server logs (such as IP addresses required to transmit network packets) may exist temporarily on web mirrors, but are never tied to individual user profiles.

---

### 3. Open Source Transparency & Auditability
Ray OS is built upon Debian GNU/Linux and distributed under free software licenses. All build scripts (`build_iso.sh`), desktop configurations, and packages are fully open for community audit.

---

### 4. Contact
For privacy questions or inquiries:
* **Email:** privacy@rayplayer.app
* **Website:** https://rayplayer.app
