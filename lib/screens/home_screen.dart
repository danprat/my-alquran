import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../widgets/surah_card.dart';
import '../widgets/last_read_card.dart';
import '../widgets/ad_widgets.dart';
import '../widgets/search_dialog.dart';
import '../services/quran_api_service.dart';
import '../services/admob_service.dart';
import 'surah_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<Surah> surahs = [];
  bool isLoading = true;
  String? errorMessage;
  late InterstitialAdManager _interstitialAdManager;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    _tabController.dispose();
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
            Icons.menu,
            color: Color(0xFF7B68EE),
          ),
          onPressed: () {
            // TODO: Implement menu
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Asslamualaikum',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tanvir Ahassan',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 24),
            
            // Last Read Card
            const LastReadCard(),
            const SizedBox(height: 16),
            
            // Banner Ad
            const BannerAdWidget(),
            const SizedBox(height: 16),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF7B68EE),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Surah'),
                  Tab(text: 'Para'),
                  Tab(text: 'Halaman'),
                  Tab(text: 'Juz'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Surah List
                  _buildSurahList(),
                  // Para placeholder
                  const Center(
                    child: Text(
                      'Konten para akan segera hadir...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  // Page placeholder
                  const Center(
                    child: Text(
                      'Konten halaman akan segera hadir...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  // Hijb placeholder
                  const Center(
                    child: Text(
                      'Konten juz akan segera hadir...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF7B68EE),
          unselectedItemColor: Colors.grey[400],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 
                      ? const Color(0xFF7B68EE).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.book_outlined),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 
                      ? const Color(0xFF7B68EE).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_outlined),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 2 
                      ? const Color(0xFF7B68EE).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_outlined),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 3 
                      ? const Color(0xFF7B68EE).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.explore_outlined),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 4 
                      ? const Color(0xFF7B68EE).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bookmark_border),
              ),
              label: '',
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
              // Show native ad every 10 items
              if ((index + 1) % 10 == 0 && index < surahs.length - 1)
                const NativeAdWidget(),
            ],
          );
        },
      ),
    );
  }
}