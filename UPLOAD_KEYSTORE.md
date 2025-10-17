# 🔑 Upload Keystore Information

## ✅ **Upload Key untuk Play App Signing**

**Created**: 17 Oktober 2025  
**Purpose**: Sign AAB untuk upload ke Play Store

---

## 🔐 **Keystore Details**

```yaml
Filename: upload-keystore.jks
Location: Project root (/Users/danypratmanto/Documents/Muslim-flutter/)
Algorithm: RSA 2048-bit
Validity: 10,000 days (~27 years)
Alias: upload
Store Password: android
Key Password: android
```

### Distinguished Name:
```
CN=Cahaya Ilahi
OU=Cahaya Ilahi
O=Cahaya Ilahi
L=Tegal
ST=Jawa Tengah
C=ID
```

---

## 🎯 **Purpose**

### Upload Key (Anda):
- ✅ Sign AAB sebelum upload ke Play Console
- ✅ Password sederhana: "android"
- ✅ Bisa di-reset jika hilang

### App Signing Key (Google):
- ✅ Google generate dan manage
- ✅ Sign APK final untuk distribusi
- ✅ Protected & backed up by Google
- ✅ **TIDAK BISA** di-reset (Google yang pegang)

---

## 🔄 **Workflow**

```
1. Developer → Build AAB dengan upload key
2. Upload AAB ke Play Console
3. Google → Verify upload key signature
4. Google → Re-sign dengan app signing key
5. Google → Distribute signed APK ke users
```

---

## ⚠️ **IMPORTANT**

### ✅ **DO:**
- ✅ Backup upload-keystore.jks ke safe location
- ✅ Remember password: "android"
- ✅ Use untuk semua future updates

### ❌ **DON'T:**
- ❌ JANGAN commit keystore ke Git (sudah di .gitignore)
- ❌ JANGAN share keystore file
- ❌ JANGAN ganti password (untuk konsistensi)

---

## 🔄 **Jika Kehilangan Upload Key**

Jika Anda kehilangan `upload-keystore.jks`:

1. **Play Console** → **Setup → App signing**
2. Klik **"Request upload key reset"**
3. Google akan generate upload key baru
4. Download new upload key
5. Update build.gradle dengan key baru
6. ✅ App signing key tetap sama (users tidak terpengaruh!)

**Ini keuntungan Play App Signing**: Upload key bisa di-reset, app signing key tetap aman!

---

## 📝 **How to View Keystore Info**

```bash
keytool -list -v -keystore upload-keystore.jks -alias upload -storepass android
```

### Get SHA-1 and SHA-256:
```bash
keytool -list -v -keystore upload-keystore.jks -alias upload -storepass android | grep SHA
```

**Note**: Untuk Firebase/Google services, gunakan SHA dari **App Signing Key** di Play Console, bukan upload key!

---

## 🔐 **Security Note**

### Password: "android"
Mengapa password sederhana?

1. ✅ **Upload key bisa di-reset** - Jika kehilangan, bisa request reset
2. ✅ **App signing key di Google** - Yang penting aman di Google
3. ✅ **Mudah diingat** - Tidak perlu password manager
4. ✅ **Best practice** - Recommended untuk Play App Signing

**Note**: Ini berbeda dengan manual keystore di mana password harus complex karena tidak bisa di-reset!

---

## 📊 **Summary**

```yaml
Upload Keystore:
  File: upload-keystore.jks
  Password: android (both store & key)
  Alias: upload
  Purpose: Sign AAB for upload
  Can Reset: YES ✅
  Location: Project root (NOT in Git)

App Signing Key:
  Managed By: Google
  Purpose: Sign APK for distribution
  Can Reset: NO (Google manages)
  Location: Google's secure infrastructure
```

---

## ✅ **Checklist**

- [x] Keystore created: upload-keystore.jks
- [x] Password set: android
- [x] Configured in build.gradle
- [x] Added to .gitignore
- [x] Build successful with signing
- [x] AAB signed and ready for upload

---

**Status**: ✅ Ready  
**AAB**: Signed with upload key  
**Size**: 48.9 MB  
**Ready for**: Play Console upload
