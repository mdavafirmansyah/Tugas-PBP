import 'animasi_series.dart';

class Donghua extends AnimasiSeries {
  final String originCountry = "China"; // Properti unik untuk Donghua
  bool _is3D;

  Donghua(
    super.title,
    super.studio,
    super.year,
    super.imagePath,
    super.synopsis,
    this._is3D,
  );

  bool get is3D => _is3D;
  set is3D(bool value) => _is3D = value;

  @override
  String getInfo() {
    String format = _is3D ? "3D" : "2D";
    return "$title [Donghua] ($year) - Studio: $studio";
  }
}
