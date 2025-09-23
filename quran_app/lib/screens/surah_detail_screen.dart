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
  bool _isPlayerVisible = false;
  String? _currentAudioUrl;
  String? _currentTitle;
  
  void _showSearchDialog() {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur pencarian dalam surah akan segera hadir'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showPlayer(String audioUrl, String title) {
    setState(() {
      _currentAudioUrl = audioUrl;
      _currentTitle = title;
      _isPlayerVisible = true;
    });
  }

  void _hidePlayer() {
    setState(() {
      _isPlayerVisible = false;
      _currentAudioUrl = null;
      _currentTitle = null;
    });
  }

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
      ),
      body: Stack(
        children: [
          // Main content
          isLoading
              ? _buildLoadingWidget()
              : errorMessage != null
                  ? _buildErrorWidget()
                  : surahDetail != null
                      ? _buildContent()
                      : const Center(child: Text('Data tidak tersedia')),
          // Floating Audio Player Overlay
          Offstage(
            offstage: !_isPlayerVisible || _currentAudioUrl == null || _currentTitle == null,
            child: Stack(
              children: [
                // Background overlay to capture taps outside the player
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _hidePlayer,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                // Audio player positioned at the bottom
                if (_currentAudioUrl != null && _currentTitle != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 80, // Positioned above the ad banner
                    child: AudioPlayerWidget(
                      audioUrl: _currentAudioUrl!,
                      title: _currentTitle!,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
    final detail = surahDetail;
    if (detail == null) {
      return const Center(
        child: Text(
          'Data surah tidak tersedia',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        // Surah Header Card (Smaller)
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7B68EE),
                Color(0xFF9A82FF),
                Color(0xFFB794FF),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B68EE).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Surah Name
              Text(
                detail.namaLatin,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Meaning
              Text(
                detail.arti,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              // Revelation and Verses
              Text(
                '${detail.tempatTurun.toUpperCase()} • ${detail.jumlahAyat} AYAT',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              // Bismillah (only show for surahs other than Al-Fatihah and At-Taubah)
              if (detail.nomor != 1 && detail.nomor != 9)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 12),
              // Audio Player Button
              ElevatedButton.icon(
                onPressed: () {
                  if (detail.audio.isNotEmpty) {
                    _showPlayer(
                      detail.audio,
                      'Audio Surah ${detail.namaLatin}',
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Audio surah tidak tersedia'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                label: Text(
                  'Putar Audio Surah',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        

        // Verses List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: detail.ayat.length,
            itemBuilder: (context, index) {
              if (index >= detail.ayat.length) {
                return const SizedBox();
              }
              final verse = detail.ayat[index];
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
                    // Verse Number and Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Share verse
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Play verse audio
                                if (verse.audioUrl != null && verse.audioUrl!.isNotEmpty) {
                                  _showPlayer(
                                    verse.audioUrl!,
                                    'Audio Ayat ${verse.nomor}',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Audio untuk ayat ini tidak tersedia'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Bookmark verse
                              },
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                          fontSize: 24,
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
                            fontSize: 14,
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
                        fontSize: 16,
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