# Dokumentasi Proses Build APK Flutter

## 1. Persyaratan Sistem

Sebelum melakukan build APK, pastikan sistem Anda memenuhi persyaratan berikut:

- **Flutter**: Versi 3.35.4 atau lebih tinggi
- **Android SDK**: Terinstal dan dikonfigurasi dengan benar
- **Android NDK**: Versi 27.0.12077973
- **Java JDK**: Versi 11

## 2. Langkah-langkah Build

Ikuti langkah-langkah berikut untuk membangun APK Flutter:

1. **Pastikan semua dependensi Flutter terinstal**:
   ```bash
   flutter pub get
   ```

2. **Bersihkan project**:
   ```bash
   flutter clean
   ```

3. **Pastikan struktur direktori assets benar**:
   - Direktori `assets/fonts` dengan file:
     - `Amiri-Regular.ttf`
     - `Amiri-Bold.ttf`
   - Direktori `assets/icons` dengan minimal satu file (misalnya `placeholder.png`)
   - Direktori `assets/images` (bisa kosong)

4. **Jalankan build APK**:
   ```bash
   flutter build apk --release
   ```

## 3. Troubleshooting

Jika mengalami masalah selama proses build, ikuti panduan berikut:

- **Error terkait NDK**: 
  Pastikan file `source.properties` ada di direktori NDK Anda.

- **Error terkait aset**:
  Periksa kembali struktur direktori `assets` dan pastikan semua file yang diperlukan tersedia.

- **Error Gradle**:
  Coba bersihkan cache Gradle dengan perintah berikut:
  ```bash
  cd android && ./gradlew clean
  ```

## 4. Lokasi Output

Setelah proses build selesai, file APK akan dihasilkan di lokasi berikut:

```
build/app/outputs/flutter-apk/app-release.apk
```

Pastikan untuk memverifikasi file APK yang dihasilkan sebelum distribusi.