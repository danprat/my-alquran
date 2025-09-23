import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../services/quran_api_service.dart';
import '../services/admob_service.dart';
import '../widgets/ad_widgets.dart';
import '../widgets/audio_player_widget.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({
    super.key,
    required this.surah,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  SurahDetail? surahDetail;
  bool isLoading = true;
  String? errorMessage;
  late RewardedAdManager _rewardedAdManager;
  double _arabicFontSize = 24.0;
  double _indonesianFontSize = 16.0;
  double _transliterationFontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _rewardedAdManager = RewardedAdManager();
    _rewardedAdManager.loadRewardedAd();
    _loadSurahDetail();
  }

  @override
  void dispose() {
    _rewardedAdManager.dispose();
    super.dispose();
  }

  Future<void> _loadSurahDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final detail = await QuranApiService.getSurahDetail(widget.surah.nomor);
      
      setState(() {
        surahDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF7B68EE),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.surah.namaLatin,
          style: GoogleFonts.poppins(
            color: const Color(0xFF7B68EE),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Font size decrease button
          IconButton(
            icon: const Text(
              'A-',
              style: TextStyle(
                color: Color(0xFF7B68EE),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                if (_arabicFontSize > 16.0) {
                  _arabicFontSize -= 2.0;
                  _indonesianFontSize -= 1.0;
                  _transliterationFontSize -= 1.0;
                }
              });
            },
          ),
          // Font size increase button
          IconButton(
            icon: const Text(
              'A+',
              style: TextStyle(
                color: Color(0xFF7B68EE),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                if (_arabicFontSize < 32.0) {
                  _arabicFontSize += 2.0;
                  _indonesianFontSize += 1.0;
                  _transliterationFontSize += 1.0;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF7B68EE),
            ),
            onPressed: () {
              // TODO: Implement search in surah
            },
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingWidget()
          : errorMessage != null
              ? _buildErrorWidget()
              : _buildContent(),
      floatingActionButton: _rewardedAdManager.isAdReady
          ? FloatingActionButton.extended(
              onPressed: () {
                _rewardedAdManager.showRewardedAd(
                  onUserEarnedReward: (ad, reward) {
                    print('User earned reward: ${reward.amount} ${reward.type}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Terima kasih! Anda mendapat ${reward.amount} ${reward.type}',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF7B68EE),
                      ),
                    );
                  },
                );
              },
              backgroundColor: const Color(0xFF7B68EE),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_circle_filled, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Reward',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const SafeArea(
          child: BannerAdWidget(),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat Surah...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
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
            'Gagal memuat surah',
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
            onPressed: _loadSurahDetail,
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

  Widget _buildContent() {
    if (surahDetail == null) return const SizedBox();

    return Column(
      children: [
        // Compact Surah Header Card
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7B68EE),
                Color(0xFF9A82FF),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B68EE).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left side - Arabic and Latin names
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surahDetail!.nama,
                      style: GoogleFonts.amiri(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      surahDetail!.namaLatin,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Right side - Details
              Text(
                '${surahDetail!.tempatTurun.toUpperCase()}\n${surahDetail!.jumlahAyat} AYAT',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        
        // Bismillah (only show for surahs other than Al-Fatihah and At-Taubah)
        if (surahDetail!.nomor != 1 && surahDetail!.nomor != 9)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: GoogleFonts.amiri(
                color: const Color(0xFF7B68EE),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        // Audio Player for Surah
        if (surahDetail!.audio.isNotEmpty)
          AudioPlayerWidget(
            audioUrl: surahDetail!.audio,
            title: 'Audio Surah ${surahDetail!.namaLatin}',
          ),

        // Verses List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: surahDetail!.ayat.length,
            itemBuilder: (context, index) {
              final verse = surahDetail!.ayat[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verse Number
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B68EE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${verse.nomor}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Arabic Text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        verse.ar,
                        style: GoogleFonts.amiri(
                          fontSize: _arabicFontSize,
                          height: 2.0,
                          color: const Color(0xFF2C3E50),
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Transliteration (if available)
                    if (verse.tr.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _cleanHtmlTags(verse.tr),
                          style: GoogleFonts.poppins(
                            fontSize: _transliterationFontSize,
                            height: 1.5,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    // Translation
                    Text(
                      verse.idn,
                      style: GoogleFonts.poppins(
                        fontSize: _indonesianFontSize,
                        height: 1.6,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _cleanHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}