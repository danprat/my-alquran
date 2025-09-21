import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranApiService {
  static const String baseUrl = 'https://open-api.my.id/api/quran';
  
  // Get all surahs
  static Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Surah.fromApiJson(json)).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get surah detail with verses
  static Future<SurahDetail> getSurahDetail(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SurahDetail.fromApiJson(data);
      } else {
        throw Exception('Failed to load surah detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}