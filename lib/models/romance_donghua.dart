import 'donghua.dart';

class RomanceDonghua extends Donghua {
  String _theme;

  RomanceDonghua(
    String title,
    String studio,
    int year,
    String imagePath,
    String synopsis,
    this._theme,
  ) : super(title, studio, year, imagePath, synopsis);

  // theme
  String get theme => _theme;
  set theme(String value) => _theme = value;

  @override
  String getInfo() {
    return "$title [Romance] ($year), Tema: $theme, Studio: $studio";
  }
}
