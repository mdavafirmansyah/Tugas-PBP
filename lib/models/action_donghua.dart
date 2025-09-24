import 'donghua.dart';

class ActionDonghua extends Donghua {
  String _mainCharacter;

  ActionDonghua(
    String title,
    String studio,
    int year,
    String imagePath,
    String synopsis,
    this._mainCharacter,
  ) : super(title, studio, year, imagePath, synopsis);

  // mainCharacter
  String get mainCharacter => _mainCharacter;
  set mainCharacter(String value) => _mainCharacter = value;

  @override
  String getInfo() {
    return "$title [Action] ($year), MC: $mainCharacter, Studio: $studio";
  }
}
