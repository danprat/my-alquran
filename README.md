# 📖 Al-Quran App

Aplikasi Al-Quran yang indah dan mudah digunakan, dibuat dengan Flutter dan mendukung Android 5.0+ (API Level 21).

## ✨ Fitur Utama

- 🎨 **Desain UI Modern** - Interface yang indah dan intuitif
- 📱 **Android 5.0+ Support** - Kompatibel dengan API Level 21+
- 📖 **114 Surah Lengkap** - Daftar surah dengan detail lengkap
- � **Teks Arab Asli** - Mushaf Utsmani dengan font Amiri
- 📝 **Transliterasi** - Bantuan membaca dalam huruf Latin
- 🌐 **Terjemahan Indonesia** - Terjemahan lengkap setiap ayat
- 🔖 **Last Read Tracking** - Menyimpan progres baca terakhir
- 🌐 **API Integration** - Data real-time dari open-api.my.id
- 🔄 **Offline Support** - Error handling dan pull-to-refresh
- 💰 **AdMob Integration** - 4 jenis iklan (Banner, Interstitial, Rewarded, Native)
- 📊 **Smart Ad Placement** - User experience yang optimal

## 📋 Persyaratan Sistem

### Minimum Requirements
- **Android**: 5.0 (API level 21) atau lebih tinggi
- **RAM**: 2GB
- **Storage**: 100MB ruang kosong
- **Internet**: Diperlukan untuk mengakses data Al-Quran

### Development Requirements
- **Flutter SDK**: 3.0.0 atau lebih baru
- **Dart SDK**: 2.17.0 atau lebih baru
- **Android Studio**: Arctic Fox atau lebih baru
- **JDK**: 11 atau lebih baru
- **Android SDK**: API level 21-34
- **Git**: Untuk version control

## 🛠️ Instalasi Development Environment

### 1. Install Flutter SDK

#### macOS
```bash
# Menggunakan Homebrew (Recommended)
brew install flutter

# Manual download
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.0.0-stable.zip
unzip flutter_macos_3.0.0-stable.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Windows
1. Download [Flutter SDK Windows](https://flutter.dev/docs/get-started/install/windows)
2. Extract ke `C:\flutter`
3. Tambahkan `C:\flutter\bin` ke System PATH

#### Linux
```bash
sudo snap install flutter --classic
```

### 2. Setup PATH Environment
```bash
# Tambahkan ke ~/.zshrc (macOS) atau ~/.bashrc (Linux)
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"

# Reload shell
source ~/.zshrc  # atau source ~/.bashrc
```

### 3. Verifikasi Flutter Installation
```bash
flutter doctor
```

Output yang diharapkan:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.0.0, on macOS 12.0)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS (optional)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] VS Code (version 1.68)
[✓] Connected device (1 available)
```

### 4. Install Android Studio & SDK

1. **Download dan Install Android Studio**
   - Download dari [developer.android.com/studio](https://developer.android.com/studio)
   - Install sesuai OS Anda

2. **Setup Android SDK**
   ```
   Android Studio → More Actions → SDK Manager → SDK Platforms
   ```
   Install:
   - ✅ Android 14.0 (API 34) - Target SDK
   - ✅ Android 13.0 (API 33)
   - ✅ Android 12.0 (API 31)
   - ✅ Android 10.0 (API 29)
   - ✅ Android 5.0 (API 21) - Minimum SDK

3. **Install SDK Tools**
   ```
   SDK Manager → SDK Tools
   ```
   Install:
   - ✅ Android SDK Build-Tools 34.0.0
   - ✅ Android SDK Command-line Tools (latest)
   - ✅ Android SDK Platform-Tools
   - ✅ Google Play services

### 5. Setup Android Device/Emulator

#### Option A: Physical Device
1. Enable **Developer Options**:
   - Settings → About Phone → tap Build Number 7x
2. Enable **USB Debugging**:
   - Settings → Developer Options → USB Debugging
3. Connect device via USB
4. Verify: `flutter devices`

#### Option B: Android Emulator
1. **Create AVD**:
   ```
   Android Studio → Tools → AVD Manager → Create Virtual Device
   ```
2. **Select Device**: Pixel 4 atau Pixel 6 (Recommended)
3. **Download System Image**: API 30+ (Android 11+)
4. **Start Emulator** dan verify: `flutter devices`

## � Setup Project

### 1. Clone Repository
```bash
git clone https://github.com/danprat/my-alquran.git
cd my-alquran
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Setup
```bash
# Check Flutter setup
flutter doctor

# Check connected devices
flutter devices

# Analyze project
flutter analyze
```

## 🏃‍♂️ Running the App

### Development Mode
```bash
# Run in debug mode (dengan hot reload)
flutter run

# Run pada device tertentu
flutter run -d [device-id]

# Run dengan verbose output
flutter run -v
```

### Release Mode (Testing)
```bash
# Run in release mode untuk test performa
flutter run --release
```

## 🔨 Build untuk Production

### 1. Build APK (Android Package)
```bash
# Build APK release
flutter build apk --release

# Build APK dengan split per ABI (ukuran lebih kecil)
flutter build apk --release --split-per-abi

# Build APK debug untuk testing
flutter build apk --debug
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk` (~50MB)

### 2. Build AAB (Android App Bundle)
```bash
# Build AAB untuk Google Play Store
flutter build appbundle --release

# Build AAB dengan obfuscation (security)
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### 3. Build Optimization
```bash
# Analyze bundle size
flutter build apk --analyze-size

# Build dengan tree shaking (remove unused code)
flutter build apk --release --tree-shake-icons

# Build untuk specific architecture
flutter build apk --release --target-platform android-arm64
```

## 📱 Deployment ke Google Play Store

### 1. Generate Signing Key
```bash
# Buat keystore
keytool -genkey -v -keystore my-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Simpan keystore di android/app/
mv my-release-key.keystore android/app/
```

### 2. Configure Signing
Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=my-key-alias
storeFile=my-release-key.keystore
```

### 3. Update build.gradle
```gradle
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
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
        }
    }
}
```

### 4. Build Final AAB
```bash
flutter build appbundle --release
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues
```bash
# Fix Android licenses
flutter doctor --android-licenses

# Update Flutter
flutter upgrade

# Clear cache
flutter clean
flutter pub get
```

#### 2. Build Issues
```bash
# Clean build
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# Fix Gradle issues
cd android && ./gradlew build && cd ..

# Update dependencies
flutter pub upgrade
```

#### 3. Device Connection Issues
```bash
# Restart ADB
adb kill-server
adb start-server

# List devices
adb devices
flutter devices
```

#### 4. Memory Issues
```bash
# Increase Gradle memory
# android/gradle.properties
org.gradle.jvmargs=-Xmx4G -XX:MaxPermSize=512m
```

### Performance Tips

#### 1. Optimize Build Size
- Use `--split-per-abi` untuk APK yang lebih kecil
- Enable R8/ProGuard untuk code shrinking
- Compress images dalam folder `assets/`
- Gunakan vector graphics (SVG) instead of bitmap

#### 2. Improve App Performance
- Use `const` constructors
- Implement lazy loading untuk data
- Optimize image sizes
- Use `AnimationController` dengan care
- Profile app dengan `flutter run --profile`

## Screenshots

Aplikasi ini mengikuti desain yang telah disediakan dengan:
1. Splash screen dengan ilustrasi Quran dan tombol "Get Started"
2. Home screen dengan greeting, last read card, dan daftar Surah
3. Detail Surah dengan teks Arab dan terjemahan

## Persyaratan Sistem

- Flutter SDK 3.0.0+
- Dart 2.17.0+
- Android SDK dengan API Level 21+ (Android 5.0+)
- Android Studio atau VS Code dengan ekstensi Flutter

## Instalasi

1. **Clone atau download project ini**
   ```bash
   git clone <repository-url>
   cd quran_app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Android (jika belum ada)**
   - Install Android Studio
   - Setup Android SDK
   - Create Android Virtual Device (AVD) atau connect physical device

4. **Run aplikasi**
   ```bash
   flutter run
   ```

## Struktur Project

```
lib/
├── main.dart                      # Entry point aplikasi
├── models/
│   └── surah.dart                # Model data Surah, Verse, dan SurahDetail
├── services/
│   └── quran_api_service.dart    # Service untuk API calls
├── screens/
│   ├── splash_screen.dart        # Splash screen dengan animasi
│   ├── home_screen.dart          # Home screen utama dengan API integration
│   └── surah_detail_screen.dart  # Detail Surah dengan API data
└── widgets/
    ├── last_read_card.dart       # Widget kartu last read dengan persistence
    └── surah_card.dart           # Widget kartu Surah
```

## Konfigurasi Android

Aplikasi ini dikonfigurasi untuk mendukung Android 5.0+ dengan pengaturan:

- `minSdkVersion 21` (Android 5.0)
- `targetSdkVersion 34` (Android 14)
- `compileSdkVersion 34`

## Dependencies

- `flutter`: Framework utama
- `google_fonts`: Font Poppins dan Amiri untuk UI yang indah
- `http`: HTTP client untuk API Quran calls
- `shared_preferences`: Local storage untuk last read
- `flutter_svg`: SVG support
- `cupertino_icons`: iOS style icons
- `google_mobile_ads`: Google AdMob integration
- `connectivity_plus`: Network connectivity checking
- `path_provider`: File system paths

## AdMob Integration

Aplikasi telah terintegrasi dengan Google AdMob menggunakan Demo Ad Unit IDs:

| Jenis Iklan | ID Demo | Implementasi |
|-------------|---------|--------------|
| Banner Adaptif | `ca-app-pub-3940256099942544/9214589741` | Home & Detail screen |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` | Setiap 5 klik surah |
| Rewarded Video | `ca-app-pub-3940256099942544/5224354917` | FAB di detail screen |
| Native Advanced | `ca-app-pub-3940256099942544/2247696110` | Setiap 10 item list |

**📖 Dokumentasi lengkap**: Lihat [ADMOB_INTEGRATION.md](ADMOB_INTEGRATION.md)

## Pengembangan Selanjutnya

Fitur yang dapat ditambahkan:
- [ ] Audio recitation untuk setiap ayat (URL audio sudah tersedia)
- [ ] Search functionality dalam surah dan ayat
- [ ] Bookmark verses dengan local storage
- [ ] Prayer times dengan location services
- [ ] Qibla direction dengan compass
- [ ] Dark mode untuk reading di malam hari
- [ ] Multiple translations (English, etc)
- [ ] Tafsir integration
- [ ] **AdMob Production IDs** untuk monetization
- [ ] Analytics untuk tracking user engagement

## Build untuk Production

Untuk build APK:
```bash
flutter build apk --release
```

Untuk build AAB (Android App Bundle):
```bash
flutter build appbundle --release
```

## API Integration

Aplikasi ini menggunakan API Quran dari **open-api.my.id** dengan endpoint:

### Base URL
```
https://open-api.my.id/api/quran
```

### Endpoints
- **GET /surah** - Mendapatkan daftar semua surah
- **GET /surah/{nomor}** - Mendapatkan detail surah beserta ayat-ayatnya

### Fitur API
- ✅ 114 Surah lengkap
- ✅ Teks Arab asli
- ✅ Transliterasi Latin
- ✅ Terjemahan Bahasa Indonesia
- ✅ Audio recitation (URL audio per surah)
- ✅ Informasi tempat turun (Mekah/Madinah)
- ✅ Deskripsi dan arti nama surah

## Catatan

- ✅ Aplikasi ini menggunakan data real-time dari API
- ✅ Mendukung offline dengan error handling yang baik
- ✅ Font Google Fonts (Poppins & Amiri) untuk UI yang indah
- ✅ Pastikan device atau emulator menggunakan Android 5.0+ untuk testing
- 🌐 Memerlukan koneksi internet untuk mengakses data Al-Quran

## 🧪 Testing

### Unit Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Testing
```bash
# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Performance Testing
```bash
# Profile app performance
flutter run --profile

# Analyze build size
flutter build apk --analyze-size
```

## 📝 Development Notes

### Version Control
- Repository size optimized (~21MB after cleanup)
- `.gitignore` configured untuk exclude build files >100MB
- Git LFS tidak diperlukan untuk project ini

### Code Quality
- Mengikuti Flutter/Dart coding standards
- Organized dengan folder structure yang clean
- Proper error handling dan offline support
- Responsive design untuk berbagai screen sizes

### AdMob Revenue Optimization
- Smart ad placement untuk UX yang baik
- Frequency capping untuk avoid ad fatigue
- Rewarded ads untuk engagement
- Native ads untuk seamless integration

## 📞 Support & Kontribusi

### Reporting Issues
Jika menemukan bug atau ingin request fitur:
1. Check existing issues di GitHub
2. Buat issue baru dengan detail yang jelas
3. Include screenshot dan langkah reproduce

### Contributing
1. Fork repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📚 Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [AdMob Flutter Plugin](https://pub.dev/packages/google_mobile_ads)
- [Al-Quran API](https://open-api.my.id/api/quran)

### Design Resources
- [Material Design Guidelines](https://material.io/design)
- [Flutter UI Samples](https://flutter.github.io/samples/)
- [Islamic App Design Patterns](https://dribbble.com/tags/islamic_app)

### Learning Resources
- [Flutter Codelabs](https://codelabs.developers.google.com/codelabs?cat=Flutter)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [AdMob Best Practices](https://developers.google.com/admob/flutter/best-practices)

## 📄 License

MIT License - Silakan gunakan dan modifikasi sesuai kebutuhan.

---

**Made with ❤️ for the Muslim Community**

*Barakallahu fiikum - Semoga bermanfaat untuk semua*