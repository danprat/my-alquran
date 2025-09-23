import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hadith.dart';

class HadithApiService {
  static const String baseUrl = 'https://api.hadith.gading.dev';
  
  // Get all hadith books
  static Future<List<HadithBook>> getHadithBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Check for error in API response
        if (responseData['error'] == true) {
          throw Exception(responseData['message'] ?? 'API returned an error');
        }
        
        if (responseData['data'] != null && responseData['data'] is List) {
          final List<dynamic> books = responseData['data'];
          return books.map((bookJson) {
            if (bookJson is Map<String, dynamic>) {
              return HadithBook.fromJson(bookJson);
            } else {
              return HadithBook(id: '', name: '', slug: '', available: 0);
            }
          }).where((book) => book.id.isNotEmpty).toList();
        } else {
          throw Exception('Invalid response format: data field is not a list');
        }
      } else {
        throw Exception('Failed to load hadith books: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Invalid response format') || 
          e.toString().contains('API returned an error')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get hadiths by range
  static Future<HadithResponse> getHadithsByRange(String bookSlug, int start, int end) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$bookSlug?range=$start-$end'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Check for error in API response
        if (responseData['error'] == true) {
          throw Exception(responseData['message'] ?? 'API returned an error');
        }
        
        if (responseData['data'] != null && responseData['data'] is Map<String, dynamic>) {
          return HadithResponse.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format: data field is missing or invalid');
        }
      } else {
        throw Exception('Failed to load hadiths: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Invalid response format') || 
          e.toString().contains('API returned an error')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get specific hadith
  static Future<SingleHadith> getSpecificHadith(String bookSlug, int number) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$bookSlug?range=$number-$number'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Check for API error
        if (responseData['error'] == true) {
          throw Exception('API Error: ${responseData['message'] ?? 'Unknown error'}');
        }
        
        // Since we're using the same endpoint as getHadithsByRange,
        // we need to parse it as HadithResponse first, then extract the first hadith
        if (responseData['data'] != null) {
          final hadithResponse = HadithResponse.fromJson(responseData['data']);
          if (hadithResponse.hadiths.isNotEmpty) {
            return SingleHadith(
              name: hadithResponse.name,
              slug: hadithResponse.slug,
              hadith: hadithResponse.hadiths.first,
            );
          }
        }
        
        // Fallback if the response structure is different
        throw Exception('No hadith found for number $number');
      } else {
        throw Exception('Failed to load hadith: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('No hadith found')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}