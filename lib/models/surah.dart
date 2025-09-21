class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory Surah.fromApiJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
    );
  }

  // For backwards compatibility with existing UI
  int get number => nomor;
  String get name => namaLatin;
  String get arabicName => nama;
  String get englishName => arti;
  String get revelation => tempatTurun.toUpperCase();
  int get verses => jumlahAyat;
}

class Verse {
  final int id;
  final int surah;
  final int nomor;
  final String ar;
  final String tr;
  final String idn;

  Verse({
    required this.id,
    required this.surah,
    required this.nomor,
    required this.ar,
    required this.tr,
    required this.idn,
  });

  factory Verse.fromApiJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] ?? 0,
      surah: json['surah'] ?? 0,
      nomor: json['nomor'] ?? 0,
      ar: json['ar'] ?? '',
      tr: json['tr'] ?? '',
      idn: json['idn'] ?? '',
    );
  }

  // For backwards compatibility with existing UI
  int get number => nomor;
  String get arabic => ar;
  String get translation => idn;
  String get transliteration => tr;
}

class SurahDetail {
  final bool status;
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;
  final List<Verse> ayat;

  SurahDetail({
    required this.status,
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
    required this.ayat,
  });

  factory SurahDetail.fromApiJson(Map<String, dynamic> json) {
    var ayatList = json['ayat'] as List;
    List<Verse> verses = ayatList.map((verse) => Verse.fromApiJson(verse)).toList();

    return SurahDetail(
      status: json['status'] ?? false,
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      ayat: verses,
    );
  }

  // Convert to Surah object
  Surah toSurah() {
    return Surah(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      audio: audio,
    );
  }
}