import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../widgets/surah_card.dart';
import '../widgets/ad_widgets.dart';
import '../widgets/search_dialog.dart';
import '../services/quran_api_service.dart';
import '../services/admob_service.dart';
import 'surah_detail_screen.dart';
import 'quick_access_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Surah> surahs = [];
  bool isLoading = true;
  String? errorMessage;
  late InterstitialAdManager _interstitialAdManager;
  


  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadInterstitialAd();
    AdMobService.setContext(context);
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final loadedSurahs = await QuranApiService.getAllSurahs();
      
      setState(() {
        surahs = loadedSurahs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _showSearchDialog() {
    if (surahs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data surah belum dimuat'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchDialog(
          allSurahs: surahs,
          onSurahSelected: _onSurahSelected,
        );
      },
    );
  }

  void _onSurahSelected(Surah surah) {
    // Navigasi ke halaman detail surah
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahDetailScreen(surah: surah),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Al-Qur\'an',
          style: GoogleFonts.poppins(
            color: const Color(0xFF7B68EE),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF7B68EE),
            ),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Color(0xFF7B68EE),
          ),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const QuickAccessScreen()),
            (route) => false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Ad
            const BannerAdWidget(),
            const SizedBox(height: 16),
        
            // Content - Surah List
            Expanded(
              child: _buildSurahList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat Daftar Surah...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Periksa koneksi internet Anda',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSurahs,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68EE),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (surahs.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data surah',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSurahs,
      color: const Color(0xFF7B68EE),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return Column(
            children: [
              SurahCard(
                surah: surah,
                onTap: () {
                  // Show interstitial ad every 5th surah tap
                  if (index % 5 == 0 && index > 0 && _interstitialAdManager.isAdReady) {
                    _interstitialAdManager.showInterstitialAd();
                    // Delay navigation to allow ad to show
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailScreen(surah: surah),
                        ),
                      );
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(surah: surah),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }


}