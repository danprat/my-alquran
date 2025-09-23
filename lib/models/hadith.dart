class HadithBook {
  final String id;
  final String name;
  final String slug;
  final int available;

  HadithBook({
    required this.id,
    required this.name,
    required this.slug,
    required this.available,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['id']?.toString() ?? '', // Use 'id' as slug since API doesn't have 'slug'
      available: _parseInt(json['available']) ?? 0,
    );
  }
  
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Hadith {
  final int number;
  final String arab;
  final String id;

  Hadith({
    required this.number,
    required this.arab,
    required this.id,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: _parseInt(json['number']) ?? 0,
      arab: json['arab']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
    );
  }
  
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class HadithResponse {
  final String name;
  final String slug;
  final int total;
  final List<Hadith> hadiths;

  HadithResponse({
    required this.name,
    required this.slug,
    required this.total,
    required this.hadiths,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    List<Hadith> hadiths = [];
    
    // Handle the hadiths list safely
    if (json['hadiths'] != null && json['hadiths'] is List) {
      var hadithList = json['hadiths'] as List;
      hadiths = hadithList.map((hadith) {
        if (hadith is Map<String, dynamic>) {
          return Hadith.fromJson(hadith);
        } else {
          return Hadith(number: 0, arab: '', id: '');
        }
      }).toList();
    }

    return HadithResponse(
      name: json['name']?.toString() ?? '',
      slug: json['id']?.toString() ?? '', // Use 'id' as slug
      total: _parseInt(json['available']) ?? 0, // Use 'available' as total
      hadiths: hadiths,
    );
  }
  
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class SingleHadith {
  final String name;
  final String slug;
  final Hadith hadith;

  SingleHadith({
    required this.name,
    required this.slug,
    required this.hadith,
  });

  factory SingleHadith.fromJson(Map<String, dynamic> json) {
    Hadith hadith;
    
    // Handle the hadith object safely
    if (json['hadith'] != null && json['hadith'] is Map<String, dynamic>) {
      hadith = Hadith.fromJson(json['hadith']);
    } else {
      hadith = Hadith(number: 0, arab: '', id: '');
    }
    
    return SingleHadith(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      hadith: hadith,
    );
  }
}