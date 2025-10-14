# Manual Keystore Setup untuk Play Store

## 📋 Overview
Panduan ini menjelaskan cara setup manual keystore untuk signing aplikasi Android sebelum upload ke Google Play Store.

## ✅ Keystore Sudah Dibuat
Lokasi: `/Users/danypratmanto/upload-keystore.jks`

### Detail Keystore:
- **Algoritma**: RSA 2048-bit
- **Validity**: 10,000 hari (~27 tahun)
- **Key Alias**: upload
- **Distinguished Name**:
  - CN=my.alquran
  - OU=my.alquran
  - O=my.alquran
  - L=tegal
  - ST=jawa tengah
  - C=ID

## 🔐 Konfigurasi File

### 1. File `android/key.properties`
File ini berisi kredensial keystore Anda. **JANGAN COMMIT FILE INI KE GIT!**

```properties
storePassword=yourStorePassword
keyPassword=yourKeyPassword
keyAlias=upload
storeFile=/Users/danypratmanto/upload-keystore.jks
```

**IMPORTANT**: Ganti `yourStorePassword` dan `yourKeyPassword` dengan password yang Anda buat saat generate keystore!

### 2. File `android/app/build.gradle`
Sudah dikonfigurasi untuk membaca `key.properties` dan menggunakan signing configuration.

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
        }
    }
}
```

### 3. File `.gitignore`
Pastikan file-file berikut di-ignore:

```
# Keystore files
*.jks
*.keystore
key.properties
```

## 🚀 Cara Build & Upload ke Play Store

### Step 1: Update key.properties
Edit file `android/key.properties` dan masukkan password yang benar:

```bash
cd android
nano key.properties
```

Ganti:
- `yourStorePassword` → password keystore Anda
- `yourKeyPassword` → password key Anda

### Step 2: Build App Bundle
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### Step 3: Lokasi File Output
AAB akan berada di:
```
build/app/outputs/bundle/release/app-release.aab
```

### Step 4: Upload ke Play Console

1. **Login ke Play Console**: https://play.google.com/console
2. **Pilih aplikasi Anda** atau buat aplikasi baru
3. **Navigasi ke**: Release → Production → Create new release
4. **Upload AAB**: Upload file `app-release.aab`
5. **Isi Release Notes** dan informasi lainnya
6. **Review dan Publish**

## 🔒 Keamanan Keystore

### ⚠️ SANGAT PENTING:
1. **Backup keystore Anda** (`upload-keystore.jks`) ke tempat yang aman
2. **Simpan password** di tempat yang aman (gunakan password manager)
3. **JANGAN pernah commit** keystore atau `key.properties` ke Git
4. **JANGAN share** keystore atau password ke siapapun

### 💡 Tips Keamanan:
- Simpan keystore di cloud storage (Google Drive, Dropbox, dll) dengan enkripsi
- Backup keystore di minimal 2 lokasi berbeda
- Catat password di password manager (LastPass, 1Password, dll)
- Jika kehilangan keystore, Anda TIDAK BISA update aplikasi di Play Store!

## 📝 Informasi Keystore

Untuk melihat informasi keystore:
```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

Untuk mendapatkan SHA-1 dan SHA-256 fingerprint (diperlukan untuk Firebase, Google Sign-In, dll):
```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload | grep SHA
```

## 🔄 Jika Kehilangan Keystore

Jika Anda kehilangan keystore:
1. Anda **TIDAK BISA** update aplikasi yang sudah di Play Store
2. Anda harus membuat **aplikasi baru** dengan package name berbeda
3. **Semua pengguna harus download aplikasi baru**

Ini sebabnya backup keystore sangat penting!

## ✅ Checklist Sebelum Upload

- [ ] Password sudah diupdate di `key.properties`
- [ ] Build berhasil: `flutter build appbundle --release`
- [ ] File AAB sudah ada di `build/app/outputs/bundle/release/`
- [ ] Keystore sudah di-backup ke tempat aman
- [ ] Password sudah disimpan di password manager
- [ ] `key.properties` TIDAK di-commit ke Git
- [ ] Keystore (`*.jks`) TIDAK di-commit ke Git

## 🆚 Manual Signing vs Play App Signing

### Manual Signing (Yang Anda gunakan sekarang):
✅ Anda kontrol penuh atas keystore
✅ Bisa digunakan untuk distribusi di luar Play Store
✅ Tidak tergantung pada Google
⚠️ Risiko kehilangan keystore lebih tinggi
⚠️ Anda bertanggung jawab penuh atas keamanan keystore

### Play App Signing:
✅ Google backup dan kelola keystore untuk Anda
✅ Lebih aman dari kehilangan keystore
✅ Bisa reset upload key jika kehilangan
⚠️ Hanya bisa digunakan untuk Play Store
⚠️ Tergantung pada infrastruktur Google

## 🎯 Next Steps

1. **Update password** di `key.properties`
2. **Test build**: `flutter build appbundle --release`
3. **Verify AAB**: Pastikan file AAB ter-generate dengan benar
4. **Upload ke Play Console**
5. **Backup keystore** segera!

## 📞 Troubleshooting

### Error: "Keystore was tampered with, or password was incorrect"
- Periksa password di `key.properties`
- Pastikan path ke keystore benar

### Error: "Failed to read key upload from store"
- Periksa `keyAlias` di `key.properties` (harus: `upload`)
- Pastikan keystore file ada di lokasi yang ditentukan

### Build berhasil tapi AAB tidak ada
- Jalankan `flutter clean` dulu
- Pastikan tidak ada error saat build
- Periksa lokasi: `build/app/outputs/bundle/release/app-release.aab`

## 📚 Resources

- [Flutter: Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Android: Sign your app](https://developer.android.com/studio/publish/app-signing)
- [Play Console: Use app signing by Google Play](https://support.google.com/googleplay/android-developer/answer/9842756)

---

**Last Updated**: October 14, 2025
**Author**: Dany Pratmanto
**App**: Cahaya Ilahi (My Al-Quran) v1.0.0+1
