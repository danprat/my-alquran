# Qu## Fitur

- 🎨 Desain UI yang indah dan modern
- 📱 Kompatibel dengan Android 5.0+ (API Level 21)
- 📖 Daftar Surah lengkap dengan detail (114 Surah)
- 🎯 Navigasi yang mudah dan intuitif
- 🌙 Splash screen yang menarik dengan animasi
- 📚 Detail Surah dengan teks Arab, transliterasi, dan terjemahan Indonesia
- 🔖 Last read tracking dengan SharedPreferences
- 🌐 Integrasi dengan API Quran (open-api.my.id)
- 🔄 Pull-to-refresh dan error handling
- 🎨 Gradien warna yang cantik sesuai desain
- ⚡ Loading indicators dan offline handling
- 💰 **AdMob Integration** dengan 4 jenis iklan (Banner, Interstitial, Rewarded, Native)
- 📊 Smart ad placement untuk user experience yang baiktter

Aplikasi Al-Quran yang indah dan mudah digunakan, dibuat dengan Flutter dan mendukung Android 5.0+ (API Level 21).

## Fitur

- 🎨 Desain UI yang indah dan modern
- 📱 Kompatibel dengan Android 5.0+ (API Level 21)
- 📖 Daftar Surah lengkap dengan detail (114 Surah)
- 🎯 Navigasi yang mudah dan intuitif
- 🌙 Splash screen yang menarik dengan animasi
- 📚 Detail Surah dengan teks Arab, transliterasi, dan terjemahan Indonesia
- 🔖 Last read tracking dengan SharedPreferences
- � Integrasi dengan API Quran (open-api.my.id)
- 🔄 Pull-to-refresh dan error handling
- �🎨 Gradien warna yang cantik sesuai desain
- ⚡ Loading indicators dan offline handling

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

## License

MIT License - Silakan gunakan dan modifikasi sesuai kebutuhan.