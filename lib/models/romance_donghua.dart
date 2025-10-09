import 'donghua.dart';

class RomanceDonghua extends Donghua {
  String _theme;

  RomanceDonghua(
    super.title,
    super.studio,
    super.year,
    super.imagePath,
    super.synopsis,
    this._theme,
  );

  // theme
  String get theme => _theme;
  set theme(String value) => _theme = value;

  @override
  String getInfo() {
    return "$title [Romance] ($year), Tema: $theme, Studio: $studio";
  }
}
