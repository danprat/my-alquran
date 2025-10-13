# AdMob Integration Guide - Muslim Flutter

## Overview
Aplikasi Quran telah diintegrasikan dengan Google AdMob menggunakan ID demo untuk testing. Berikut adalah jenis iklan yang telah diimplementasikan:

## Ad Unit IDs (Demo)

| Jenis Iklan | ID Unit Iklan Demo |
|-------------|-------------------|
| Banner Adaptif | `ca-app-pub-3940256099942544/9214589741` |
| Interstisial | `ca-app-pub-3940256099942544/1033173712` |
| Rewarded Video | `ca-app-pub-3940256099942544/5224354917` |
| Native Advanced | `ca-app-pub-3940256099942544/2247696110` |

## Implementation Details

### 1. Banner Ads
- **Lokasi**: Home screen (setelah Last Read Card)
- **Lokasi**: Bottom Surah Detail screen
- **Type**: Standard Banner (320x50)
- **Widget**: `BannerAdWidget`

### 2. Interstitial Ads
- **Trigger**: Setiap 5 surah yang diklik (setelah surah ke-5, 10, 15, dst.)
- **Timing**: Ditampilkan sebelum navigasi ke detail surah
- **Manager**: `InterstitialAdManager`

### 3. Rewarded Video Ads
- **Lokasi**: Floating Action Button di Surah Detail screen
- **Reward**: User mendapat reward points (simulasi)
- **Manager**: `RewardedAdManager`

### 4. Native Ads
- **Lokasi**: Setiap 10 item dalam list surah (setelah surah ke-10, 20, 30, dst.)
- **Size**: 120px height
- **Widget**: `NativeAdWidget`

## Files Structure

```
lib/
├── services/
│   └── admob_service.dart      # AdMob service & managers
├── widgets/
│   └── ad_widgets.dart         # Banner & Native ad widgets
└── screens/
    ├── home_screen.dart        # Banner + Interstitial + Native ads
    └── surah_detail_screen.dart # Banner + Rewarded ads
```

## Configuration Files

### Android Manifest
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```

### Dependencies
```yaml
# pubspec.yaml
dependencies:
  google_mobile_ads: ^5.1.0
```

## Features

### ✅ Implemented
- [x] Banner ads dengan loading state
- [x] Interstitial ads dengan smart timing
- [x] Rewarded video ads dengan reward system
- [x] Native ads dalam list view
- [x] Error handling untuk ad loading
- [x] Ad disposal untuk memory management
- [x] Loading indicators untuk better UX

### 🔄 Ad Display Logic
1. **Banner Ads**: Selalu ditampilkan di home dan detail screen
2. **Interstitial**: Setiap 5 klik surah (index % 5 == 0)
3. **Native Ads**: Setiap 10 item dalam list (index % 10 == 0)
4. **Rewarded**: On-demand melalui FAB button

### 💡 User Experience
- Loading placeholders untuk semua jenis ad
- Non-intrusive ad placement
- Rewarded ads sebagai optional feature
- Error handling yang graceful

## For Production

### Ganti Demo IDs dengan Real Ad Unit IDs:
1. Buat akun Google AdMob
2. Buat aplikasi baru di AdMob console
3. Generate Ad Unit IDs untuk setiap jenis iklan
4. Update `AdMobService` dengan ID production
5. Update App ID di AndroidManifest.xml

### Testing
- Test dengan demo IDs terlebih dahulu
- Pastikan ads loading dengan baik
- Test di berbagai ukuran layar
- Test network error scenarios

## Revenue Optimization Tips
1. **Banner Placement**: Tempatkan di area dengan high visibility
2. **Interstitial Timing**: Jangan terlalu sering (user experience)
3. **Rewarded Ads**: Berikan incentive yang menarik
4. **Native Ads**: Blend dengan content untuk better CTR

## Compliance
- Pastikan content policy AdMob compliance
- Implement GDPR consent jika diperlukan
- Age-appropriate content rating
- Transparent privacy policy