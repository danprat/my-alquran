# Panduan Build Aplikasi Muslim Flutter

## Prasyarat
- Flutter SDK >= 3.0.0
- Dart SDK >= 2.17.0
- Android Studio atau VS Code
- Git

## Langkah-langkah Build

### 1. Clone Repository
```bash
git clone [repository-url]
cd Muslim-flutter
```

### 2. Masuk ke Direktori Aplikasi
```bash
cd quran_app
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Verifikasi Setup Flutter
```bash
flutter doctor
```

### 5. Build untuk Platform yang Diinginkan

#### Android (Debug)
```bash
flutter build apk --debug
```

#### Android (Release)
```bash
flutter build apk --release
```

#### Android App Bundle (untuk Google Play Store)
```bash
flutter build appbundle --release
```

#### iOS (hanya di macOS)
```bash
flutter build ios --release
```

### 6. Menjalankan Aplikasi
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Untuk device tertentu
flutter run -d [device-id]
```

### 7. Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## Struktur Project
- `lib/` - Source code utama
- `assets/` - Asset gambar, font, dan file lainnya
- `android/` - Konfigurasi Android
- `ios/` - Konfigurasi iOS
- `test/` - Unit tests

## Dependencies Utama
- `http` - HTTP requests untuk API Quran
- `shared_preferences` - Local storage
- `audioplayers` - Audio player untuk tilawah
- `google_fonts` - Font Google
- `google_mobile_ads` - Iklan mobile

## Troubleshooting
- Jika ada error dependencies, jalankan `flutter clean` lalu `flutter pub get`
- Pastikan Android SDK dan tools sudah terinstall untuk build Android
- Untuk iOS, pastikan Xcode sudah terinstall dan ter-update

## Catatan Penting
- File ini dibuat untuk memudahkan proses build dan deployment
- Pastikan semua dependencies sudah terinstall sebelum build
- Untuk production build, gunakan flag `--release`