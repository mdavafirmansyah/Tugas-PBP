import 'animasi_series.dart';

class Anime extends AnimasiSeries {
  final String originCountry = "Japan"; // Properti unik untuk Anime
String _source;

  Anime(
    super.title,
    super.studio,
    super.year,
    super.imagePath,
    super.synopsis,
    this._source,
  );

  String get source => _source;
  set source(String value) => _source = value;

  @override
  String getInfo() {
    // Memberikan info spesifik untuk Anime
    return "$title [Anime] ($year) - Studio: $studio";
  }
}