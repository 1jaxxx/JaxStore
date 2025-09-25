// lib/model/paket_jasa.dart
class PaketJasa {
  final String id;
  final String judul;
  final String deskripsi;
  final int harga;
  final String estimasi;
  final String rankAwalUrl;
  final String rankTujuanUrl;

  PaketJasa({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.harga,
    required this.estimasi,
    required this.rankAwalUrl,
    required this.rankTujuanUrl,
  });
}