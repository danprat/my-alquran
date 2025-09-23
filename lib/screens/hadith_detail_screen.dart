import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/hadith.dart';
import '../services/hadith_api_service.dart';
import '../widgets/ad_widgets.dart';

class HadithDetailScreen extends StatefulWidget {
  final HadithBook hadithBook;

  const HadithDetailScreen({
    super.key,
    required this.hadithBook,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  List<Hadith> hadiths = [];
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  final int itemsPerPage = 50;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHadiths();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMoreData) {
        _loadMoreHadiths();
      }
    }
  }

  Future<void> _loadHadiths() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final start = 1;
      final end = itemsPerPage;
      
      final response = await HadithApiService.getHadithsByRange(
        widget.hadithBook.slug,
        start,
        end,
      );
      
      setState(() {
        hadiths = response.hadiths;
        isLoading = false;
        currentPage = 1;
        hasMoreData = response.hadiths.length == itemsPerPage;
      });
    } catch (e) {
      print('Error loading hadiths: $e'); // Debug print
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat hadist: ${e.toString().replaceFirst('Exception: ', '')}';
      });
    }
  }

  Future<void> _loadMoreHadiths() async {
    try {
      final start = (currentPage * itemsPerPage) + 1;
      final end = start + itemsPerPage - 1;
      
      // Don't load more if we've reached the total available
      if (start > widget.hadithBook.available) {
        setState(() {
          hasMoreData = false;
        });
        return;
      }
      
      final response = await HadithApiService.getHadithsByRange(
        widget.hadithBook.slug,
        start,
        end > widget.hadithBook.available ? widget.hadithBook.available : end,
      );
      
      setState(() {
        hadiths.addAll(response.hadiths);
        currentPage++;
        hasMoreData = response.hadiths.length == itemsPerPage && 
                     hadiths.length < widget.hadithBook.available;
      });
    } catch (e) {
      print('Error loading more hadiths: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat hadist: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cari Hadist',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor hadist (1-${widget.hadithBook.available})',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                final number = int.tryParse(value);
                if (number != null && number >= 1 && number <= widget.hadithBook.available) {
                  Navigator.pop(context);
                  _showSpecificHadith(number);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showSpecificHadith(int number) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
          ),
        ),
      );

      final singleHadith = await HadithApiService.getSpecificHadith(
        widget.hadithBook.slug,
        number,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Hadist No. $number',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        singleHadith.hadith.arab,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          height: 2.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      singleHadith.hadith.id,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(color: const Color(0xFF7B68EE)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat hadist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          widget.hadithBook.name,
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
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingWidget()
          : errorMessage != null
              ? _buildErrorWidget()
              : _buildContent(),
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
            'Memuat Hadist...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
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
            'Gagal memuat data',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadHadiths,
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
    return Column(
      children: [
        // Header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
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
              Text(
                widget.hadithBook.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.hadithBook.available} Hadist • ${hadiths.length} Dimuat',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        
        // Hadiths List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hadiths.length + (hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == hadiths.length) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
                    ),
                  ),
                );
              }

              final hadith = hadiths[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hadith Number
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B68EE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Hadist ${hadith.number}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF7B68EE),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Arabic Text
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        hadith.arab,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          height: 2.0,
                          color: const Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Indonesian Translation
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hadith.id,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
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
}