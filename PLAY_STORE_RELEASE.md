# 🚀 Google Play Store Release Guide - Cahaya Ilahi

## ✅ Build Complete

### Build Information
- **Build Type**: Android App Bundle (AAB)
- **File Location**: `build/app/outputs/bundle/release/app-release.aab`
- **File Size**: 46.7MB
- **Build Date**: October 11, 2025
- **App Name**: Cahaya Ilahi (My Al-Quran)
- **Version**: Check `pubspec.yaml` for version number

## 📦 What is AAB?

Android App Bundle (AAB) adalah format publishing yang direkomendasikan Google. Benefits:
- ✅ **Dynamic Delivery**: User hanya download resources yang dibutuhkan
- ✅ **Smaller Download Size**: Play Store optimasi APK per device
- ✅ **Better Performance**: Lebih efisien dari APK biasa
- ✅ **Required for New Apps**: Play Store wajib AAB untuk app baru (sejak 2021)

## 📋 Pre-Upload Checklist

### 1. ✅ Verifikasi Build
```bash
# Check file exists
ls -lh build/app/outputs/bundle/release/app-release.aab

# Expected output: ~46.7MB
```

### 2. ✅ App Configuration Check
- [x] AdMob Production IDs configured
- [x] App ID: `ca-app-pub-2723286941548361~6686030833`
- [x] Banner & Interstitial ads active
- [x] Rewarded & Native ads removed
- [x] Internet permission enabled
- [x] Network state permission enabled

### 3. ✅ Version Information
Check in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+buildNumber`
- **1.0.0**: Version name (user-facing)
- **+1**: Version code (internal, must increment for each release)

### 4. ⚠️ App Signing
**IMPORTANT**: Play Store requires app signing. Dua options:

#### Option A: Play App Signing (Recommended ⭐)
- Google manages signing key
- Upload AAB langsung
- Google akan sign secara otomatis
- Lebih aman, key management by Google

#### Option B: Manual Signing
- Anda manage signing key sendiri
- Perlu generate keystore dan sign AAB
- More control tapi more responsibility

**Untuk first upload, Google akan minta pilih signing method.**

## 🔐 Manual Signing (Optional)

Jika ingin manual signing:

### 1. Generate Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Jawab pertanyaan:
# - Nama: Your Name
# - Organisasi: Your Organization
# - Kota: Your City
# - Negara: ID
# 
# SIMPAN PASSWORD dengan AMAN!
```

### 2. Configure Signing in Android
Create `android/key.properties`:
```properties
storePassword=<password dari keystore>
keyPassword=<password dari key>
keyAlias=upload
storeFile=<lokasi ke keystore>/upload-keystore.jks
```

### 3. Update `android/app/build.gradle`
```gradle
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
        }
    }
}
```

### 4. Rebuild with Signing
```bash
flutter build appbundle --release
```

## 📱 Upload to Play Console

### Step 1: Login to Play Console
1. Go to https://play.google.com/console
2. Login dengan Google Account
3. Create new application (jika belum ada)

### Step 2: App Information
Fill required information:
- **App Name**: Cahaya Ilahi
- **Short Description**: Aplikasi Al-Quran digital lengkap dengan terjemahan Indonesia
- **Full Description**: 
  ```
  Cahaya Ilahi adalah aplikasi Al-Quran digital yang lengkap dan mudah digunakan.
  
  ✨ Fitur Utama:
  • 114 Surah lengkap dengan teks Arab asli
  • Terjemahan Bahasa Indonesia
  • Transliterasi Latin
  • Audio recitation untuk setiap surah
  • Last read tracking
  • Interface yang clean dan modern
  • Responsive design
  • Gratis tanpa batasan
  
  📖 Konten:
  • Semua surah Al-Quran (114 surah)
  • Teks Arab dengan font Amiri
  • Terjemahan lengkap per ayat
  • Informasi tempat turun (Mekah/Madinah)
  • Jumlah ayat per surah
  
  🎯 Kemudahan:
  • Pull to refresh
  • Smooth scrolling
  • Pencarian surah
  • Kontrol ukuran font
  • Bookmark last read
  
  Aplikasi ini cocok untuk:
  - Membaca Al-Quran sehari-hari
  - Belajar dan menghafal
  - Memahami makna ayat
  - Referensi cepat
  
  Semoga aplikasi ini bermanfaat untuk ibadah Anda. Barakallahu fiikum.
  ```

### Step 3: Graphics Assets
Prepare assets (required):

#### App Icon
- **Size**: 512x512 px
- **Format**: PNG (32-bit)
- **No transparency**

#### Feature Graphic
- **Size**: 1024x500 px
- **Format**: PNG or JPEG
- **Showcases app in Play Store**

#### Screenshots (Minimum 2)
- **Phone**: 16:9 or 9:16 ratio
- **Recommended**: 1080x1920 px
- **Minimum**: 320px shortest side
- **Maximum**: 3840px longest side

#### Optional Assets
- Promo video
- TV banner
- Wear OS screenshots

### Step 4: Content Rating
1. Fill questionnaire
2. Categories:
   - **App Type**: Reference
   - **Content**: Religious/Spiritual
   - **Ads**: Yes (AdMob enabled)
3. Get rating certificate

### Step 5: Pricing & Distribution
- **Price**: Free
- **Countries**: Select target countries
  - Indonesia ✅
  - Malaysia ✅
  - Brunei ✅
  - Singapore ✅
  - (atau Worldwide)
- **Content Rating**: For all ages
- **Contains Ads**: Yes
- **Privacy Policy**: Required (URL to your privacy policy)

### Step 6: Upload AAB
1. **Production** → **Releases** → **Create Release**
2. Upload `app-release.aab`
3. Fill release notes:
   ```
   🎉 Initial Release - Versi 1.0.0
   
   • 114 Surah Al-Quran lengkap
   • Terjemahan Bahasa Indonesia
   • Transliterasi Latin
   • Last read tracking
   • Interface modern dan mudah digunakan
   • Audio recitation
   • Gratis tanpa batasan fitur
   ```
4. Review and rollout

## ⚠️ Important Requirements

### Privacy Policy (REQUIRED)
Google requires privacy policy URL. Should include:
- Data collection policy
- AdMob usage disclosure
- User rights
- Contact information

Example template:
```
Privacy Policy for Cahaya Ilahi

Last updated: October 11, 2025

1. Data Collection
   - We don't collect personal data
   - App uses SharedPreferences for local storage only
   - No user accounts required

2. Third-Party Services
   - Google AdMob for advertisements
   - AdMob may collect device info for ad serving
   - See AdMob privacy policy: https://policies.google.com/privacy

3. Internet Access
   - Required for Al-Quran data from API
   - Required for ads display

4. Contact
   - Email: your-email@example.com

By using this app, you agree to this privacy policy.
```

Host on:
- GitHub Pages
- Personal website
- Google Sites
- Any public URL

### Store Listing Contact
- **Email**: Must be valid email
- **Phone**: Optional but recommended
- **Website**: Optional

## 🎨 Marketing Tips

### App Title Optimization
- Keep it clear and searchable
- Include keywords: "Al-Quran", "Quran", "Islam"
- Example: "Cahaya Ilahi - Al-Quran Indonesia"

### Description SEO
Include keywords:
- Al-Quran digital
- Quran Indonesia
- Terjemahan Quran
- Baca Quran
- Aplikasi Islam
- Muslim app

### Categories
- **Primary**: Books & Reference
- **Secondary**: Education (if allowed)

### Tags
- alquran
- quran
- islam
- muslim
- indonesia
- terjemahan
- bacaan

## 📊 Post-Launch

### Monitor Performance
1. **Play Console Dashboard**
   - Installs
   - Ratings & Reviews
   - Crashes & ANRs
   - User acquisition

2. **AdMob Dashboard**
   - Ad impressions
   - Click-through rate (CTR)
   - Revenue
   - Fill rate

### Handle Reviews
- Respond to user feedback
- Fix reported bugs promptly
- Thank positive reviews
- Address negative reviews professionally

### Update Strategy
- Fix critical bugs ASAP
- Plan feature updates
- Increment version numbers properly
- Write clear release notes

## 🚀 Update Process

When ready to update:

### 1. Update Version
In `pubspec.yaml`:
```yaml
version: 1.0.1+2  # Increment version and build number
```

### 2. Build New AAB
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### 3. Upload to Play Console
- Create new release
- Upload new AAB
- Add release notes
- Review and rollout

### 4. Rollout Options
- **Staged Rollout**: Start with 20% users
- **Full Rollout**: Release to all users
- **Recommended**: Start staged, monitor, then full

## 📞 Support Resources

### Play Console Help
- [Play Console Documentation](https://support.google.com/googleplay/android-developer)
- [App Release Guide](https://developer.android.com/studio/publish)
- [Play Console Community](https://support.google.com/googleplay/android-developer/community)

### Flutter Resources
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [App Signing](https://developer.android.com/studio/publish/app-signing)

### AdMob Help
- [AdMob Policy](https://support.google.com/admob/answer/6128543)
- [Ad Placement Best Practices](https://developers.google.com/admob/android/banner)

## ✅ Final Checklist

Before submitting to Play Store:

- [ ] AAB built successfully (46.7MB)
- [ ] Version number set correctly
- [ ] AdMob production IDs configured
- [ ] App tested on multiple devices
- [ ] Screenshots prepared (minimum 2)
- [ ] App icon ready (512x512)
- [ ] Feature graphic ready (1024x500)
- [ ] Description written
- [ ] Privacy policy URL ready
- [ ] Content rating completed
- [ ] Pricing & distribution configured
- [ ] Release notes written
- [ ] App signing method chosen

## 🎉 Ready to Launch!

Your AAB is ready at:
```
build/app/outputs/bundle/release/app-release.aab
```

**File Size**: 46.7MB
**Status**: ✅ Ready for Play Store upload

---

**Good Luck! 🚀**

*Semoga aplikasi Cahaya Ilahi bermanfaat untuk banyak orang. Barakallahu fiikum!*
