# Package Name Update

## ⚠️ Package Name Changed

**Tanggal**: 14 Oktober 2025

### 🔄 Perubahan Package Name

**OLD Package**: `com.example.quran.quran_app`  
**NEW Package**: `id.cahayailahi.alquran`

### 📋 Alasan Perubahan

Package name `com.example.*` dibatasi oleh Google Play Store dan tidak diperbolehkan untuk aplikasi production. Package name baru menggunakan format yang lebih profesional:

- **id** - Country code untuk Indonesia
- **cahayailahi** - Nama brand aplikasi (Cahaya Ilahi)
- **alquran** - Nama aplikasi (Al-Quran)

### ✅ File yang Diupdate

1. **android/app/build.gradle**
   - `namespace`: `id.cahayailahi.alquran`
   - `applicationId`: `id.cahayailahi.alquran`

2. **android/app/src/main/kotlin/id/cahayailahi/alquran/MainActivity.kt**
   - Package declaration updated
   - Folder structure reorganized

### 🗂️ Struktur Folder Baru

```
android/app/src/main/kotlin/
└── id/
    └── cahayailahi/
        └── alquran/
            └── MainActivity.kt
```

### ⚠️ IMPORTANT: Keystore Harus Dibuat Ulang!

Karena package name berubah, Anda perlu:

1. **Hapus keystore lama** (opsional, tapi sebaiknya untuk kejelasan):
   ```bash
   rm ~/upload-keystore.jks
   ```

2. **Buat keystore baru** dengan distinguished name yang sesuai:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

3. **Update key.properties** dengan password baru (jika password berubah)

### 🚀 Build Ulang

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### 📱 Konsekuensi di Play Store

Karena ini adalah **package name baru**, aplikasi ini akan dianggap sebagai **aplikasi baru** di Play Store:

- ✅ **Keuntungan**: Tidak ada masalah dengan com.example restriction
- ⚠️ **Catatan**: Jika sebelumnya pernah upload dengan package lama, itu akan dianggap aplikasi berbeda
- 💡 **Rekomendasi**: Gunakan package name ini untuk publikasi pertama kali

### 🔐 Keamanan

Package name ini unik dan tidak akan konflik dengan aplikasi lain karena:
- Menggunakan domain Indonesia (id)
- Nama brand spesifik (cahayailahi)
- Nama aplikasi jelas (alquran)

### ✅ Checklist

- [x] Update namespace di build.gradle
- [x] Update applicationId di build.gradle
- [x] Update package di MainActivity.kt
- [x] Reorganisasi struktur folder
- [ ] Generate keystore baru (recommended)
- [ ] Test build AAB
- [ ] Upload ke Play Console

### 📝 Notes

Pastikan untuk:
1. **Backup keystore baru** setelah dibuat
2. **Catat password** di tempat aman
3. **Test aplikasi** setelah build ulang
4. **Verify package name** di AAB sebelum upload

---

**App Info:**
- **Nama**: Cahaya Ilahi - My Al-Quran
- **Package**: id.cahayailahi.alquran
- **Version**: 1.0.0+1
- **Platform**: Android (Play Store)
