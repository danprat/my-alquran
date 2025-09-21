import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../screens/surah_detail_screen.dart';
import '../services/quran_api_service.dart';

class SearchDialog extends StatefulWidget {
  final List<Surah> allSurahs;
  final Function(Surah) onSurahSelected;

  const SearchDialog({
    super.key,
    required this.allSurahs,
    required this.onSurahSelected,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Surah> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(widget.allSurahs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua surah
        _searchResults = List.from(widget.allSurahs);
      } else {
        // Filter berdasarkan nama latin, nama arab, arti, atau nomor surah
        _searchResults = widget.allSurahs.where((surah) {
          // Cek jika query adalah angka dan cocok dengan nomor surah
          if (_isNumeric(query)) {
            if (surah.nomor.toString() == query) {
              return true;
            }
          }
          
          // Cek berdasarkan nama latin (case insensitive)
          if (surah.namaLatin.toLowerCase().contains(query.toLowerCase())) {
            return true;
          }
          
          // Cek berdasarkan nama arab (case insensitive)
          if (surah.nama.toLowerCase().contains(query.toLowerCase())) {
            return true;
          }
          
          // Cek berdasarkan arti (case insensitive)
          if (surah.arti.toLowerCase().contains(query.toLowerCase())) {
            return true;
          }
          
          return false;
        }).toList();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan saat mencari: $e';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          children: [
            // Header dengan field pencarian
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Cari surah berdasarkan nama atau nomor...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF7B68EE),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.poppins(),
                      onChanged: _performSearch,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            
            // Divider
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            
            // Body dengan hasil pencarian
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : _searchResults.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tidak ada hasil pencarian',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Coba kata kunci lain',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final surah = _searchResults[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7B68EE),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            surah.nomor.toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        surah.namaLatin,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${surah.arti} • ${surah.jumlahAyat} Ayat',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onSurahSelected(surah);
                                      },
                                    ),
                                    if (index < _searchResults.length - 1)
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        indent: 72,
                                        color: Colors.grey,
                                      ),
                                  ],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}