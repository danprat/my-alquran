# Build Instructions - Cahaya Ilahi (My Al-Quran)

**Last Updated**: 17 Oktober 2025  
**Current Method**: Play App Signing (Google Managed) ✅

---

## 🚀 **Quick Start - Build AAB**

### Simple Command:
```bash
flutter clean
flutter build appbundle --release
```

### Output:
```
✓ Built build/app/outputs/bundle/release/app-release.aab (48.9MB)
```

**That's it!** No keystore needed - Google handles signing! 🎉

---

## 📋 **Prerequisites**

### System Requirements:

### System Requirements:
- **Flutter SDK**: 3.35.4 or higher
- **Android SDK**: Installed and configured
- **Android NDK**: Version 27.0.12077973
- **Java JDK**: Version 11

### App Information:
- **Package Name**: `id.cahayailahi.alquran`
- **Version**: 1.0.0+1
- **Signing Method**: Play App Signing (Google Managed)

---

## 🏗️ **Build Process**

### Step 1: Get Dependencies
```bash
flutter pub get
```

### Step 2: Clean Project
```bash
flutter clean
```

### Step 3: Build App Bundle (AAB)
```bash
flutter build appbundle --release
```

**Output Location:**
```
build/app/outputs/bundle/release/app-release.aab
```

---

## 📱 **Build APK (For Testing)**

If you need APK for testing (not for Play Store):

```bash
flutter build apk --release
```

**Output Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**Note**: For Play Store, always use AAB format!

---

## 🔐 **Signing Configuration**

### Current: Play App Signing ✅

**Configuration**: Google manages signing automatically

**Benefits**:
- ✅ No manual keystore needed
- ✅ Google handles key backup
- ✅ Can reset upload key if lost
- ✅ More secure

**See**: `PLAY_APP_SIGNING.md` for details

---

## 📂 **Project Structure**

### Required Assets:
```
assets/
├── fonts/
│   ├── Amiri-Regular.ttf
│   └── Amiri-Bold.ttf
├── icons/
│   └── (app icons)
└── images/
    └── (optional images)
```

---

## 🐛 **Troubleshooting**

### Error: NDK Issues
**Solution**:
```bash
# Check NDK installation
flutter doctor -v

# Reinstall NDK if needed
```

### Error: Asset Issues
**Solution**:
- Verify `assets/` folder structure
- Check `pubspec.yaml` assets configuration
- Ensure all required fonts exist

### Error: Gradle Issues
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build appbundle --release
```

### Error: Build Failed
**Solution**:
```bash
# Full clean and rebuild
flutter clean
rm -rf build/
rm -rf android/.gradle/
flutter pub get
flutter build appbundle --release
```

---

## 📦 **Output Files**

### AAB (For Play Store):
```
Location: build/app/outputs/bundle/release/app-release.aab
Size: ~48.9 MB
Use: Upload to Play Console
```

### APK (For Testing):
```
Location: build/app/outputs/flutter-apk/app-release.apk
Size: ~50+ MB
Use: Direct installation/testing only
```

---

## ✅ **Verification Checklist**

Before uploading to Play Store:
- [ ] AAB built successfully
- [ ] Package name: `id.cahayailahi.alquran`
- [ ] Version correct in `pubspec.yaml`
- [ ] No build errors
- [ ] File size reasonable (~48-50 MB)
- [ ] Tested on device (if possible)

---

## 📚 **Additional Documentation**

- **PLAY_APP_SIGNING.md** - Play App Signing details
- **PLAY_STORE_RELEASE.md** - Upload guide
- **PACKAGE_NAME_UPDATE.md** - Package name info
- **ADMOB_PRODUCTION.md** - AdMob configuration

---

## 🎯 **Summary**

### Current Build Configuration:
```yaml
App: Cahaya Ilahi - My Al-Quran
Package: id.cahayailahi.alquran
Version: 1.0.0+1
Format: AAB (Android App Bundle)
Signing: Play App Signing (Google Managed)
Size: 48.9 MB
```

### Build Command:
```bash
flutter clean && flutter build appbundle --release
```

### Upload to:
```
Google Play Console → Production Release
```

**No keystore needed** - Google handles signing! ✅

---

**Last Updated**: 17 Oktober 2025  
**Status**: 🟢 Production Ready