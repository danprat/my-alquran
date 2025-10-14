# ⚠️ ACTION REQUIRED: Update Password Keystore

## 🔑 Langkah-langkah yang HARUS dilakukan:

### 1. Edit file key.properties
```bash
cd /Users/danypratmanto/Documents/Muslim-flutter/android
nano key.properties
```

### 2. Ganti Password
File `key.properties` saat ini:
```properties
storePassword=yourStorePassword    ← GANTI INI
keyPassword=yourKeyPassword        ← GANTI INI
keyAlias=upload                    ← JANGAN DIUBAH
storeFile=/Users/danypratmanto/upload-keystore.jks  ← JANGAN DIUBAH
```

**Ganti dengan password yang Anda buat saat generate keystore tadi!**

Ingat-ingat password yang Anda ketik saat perintah keytool menanyakan:
- "Enter keystore password:" → ini untuk `storePassword`
- Password untuk key biasanya sama dengan store password → ini untuk `keyPassword`

### 3. Simpan File
- Jika pakai nano: tekan `Ctrl+O`, `Enter`, lalu `Ctrl+X`
- Jika pakai vim: tekan `Esc`, ketik `:wq`, tekan `Enter`

### 4. Test Build
```bash
flutter build appbundle --release
```

## 📋 Contoh key.properties yang Benar

Misalnya password Anda adalah: `MySecurePassword123`

```properties
storePassword=MySecurePassword123
keyPassword=MySecurePassword123
keyAlias=upload
storeFile=/Users/danypratmanto/upload-keystore.jks
```

## ❌ Error yang Terjadi
```
Failed to read key upload from store: keystore password was incorrect
```

**Penyebab**: Password di `key.properties` masih menggunakan placeholder `yourStorePassword` dan `yourKeyPassword`.

**Solusi**: Edit `android/key.properties` dan masukkan password yang BENAR!

## 🔐 PENTING!

**CATAT PASSWORD INI** di tempat yang aman (password manager)!

Jika lupa password:
- ❌ TIDAK BISA recover password
- ❌ TIDAK BISA update aplikasi di Play Store
- ❌ Harus buat keystore baru = aplikasi baru di Play Store

## ✅ Setelah Update Password

Jalankan perintah ini:
```bash
cd /Users/danypratmanto/Documents/Muslim-flutter
flutter clean
flutter build appbundle --release
```

Jika berhasil, Anda akan melihat:
```
✓ Built build/app/outputs/bundle/release/app-release.aab (XX.XMB).
```

---

**NEXT STEP**: Edit file `android/key.properties` SEKARANG dan masukkan password yang benar!
