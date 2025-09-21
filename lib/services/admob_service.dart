import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  // Demo Ad Unit IDs
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

  // Banner Ad
  static String get bannerAdUnitId {
    return _bannerAdUnitId;
  }

  // Interstitial Ad
  static String get interstitialAdUnitId {
    return _interstitialAdUnitId;
  }

  // Rewarded Ad
  static String get rewardedAdUnitId {
    return _rewardedAdUnitId;
  }

  // Native Advanced Ad
  static String get nativeAdUnitId {
    return _nativeAdUnitId;
  }

  // Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Create Banner Ad
  static BannerAd createBannerAd({
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    required Function(Ad) onAdLoaded,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => print('BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('BannerAd onAdClosed.'),
      ),
    );
  }

  // Create Adaptive Banner Ad
  static Future<BannerAd> createAdaptiveBannerAd({
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    required Function(Ad) onAdLoaded,
  }) async {
    final AnchoredAdaptiveBannerAdSize? size = 
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(AdMobService._context!).size.width.truncate(),
    );

    if (size == null) {
      throw Exception('Unable to get adaptive banner size');
    }

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => print('AdaptiveBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('AdaptiveBannerAd onAdClosed.'),
      ),
    );
  }

  static var _context;

  static void setContext(context) {
    _context = context;
  }
}

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Interstitial ad loaded.');
          _interstitialAd = ad;
          _isAdReady = true;
          _setFullScreenContentCallback();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  void _setFullScreenContentCallback() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Interstitial ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Interstitial ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _isAdReady = false;
        loadInterstitialAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Interstitial ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _isAdReady = false;
        loadInterstitialAd();
      },
    );
  }

  void showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('Interstitial ad not ready yet.');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }

  bool get isAdReady => _isAdReady;
}

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isAdReady = false;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded ad loaded.');
          _rewardedAd = ad;
          _isAdReady = true;
          _setFullScreenContentCallback();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  void _setFullScreenContentCallback() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('Rewarded ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _isAdReady = false;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Rewarded ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _isAdReady = false;
        loadRewardedAd();
      },
    );
  }

  void showRewardedAd({required Function(AdWithoutView, RewardItem) onUserEarnedReward}) {
    if (_isAdReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: onUserEarnedReward,
      );
    } else {
      print('Rewarded ad not ready yet.');
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }

  bool get isAdReady => _isAdReady;
}
