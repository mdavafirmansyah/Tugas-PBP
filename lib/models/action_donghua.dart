import 'donghua.dart';

class ActionDonghua extends Donghua {
  String _mainCharacter;

  ActionDonghua(
    super.title,
    super.studio,
    super.year,
    super.imagePath,
    super.synopsis,
    this._mainCharacter,
  );

  // mainCharacter
  String get mainCharacter => _mainCharacter;
  set mainCharacter(String value) => _mainCharacter = value;

  @override
  String getInfo() {
    return "$title [Action] ($year), MC: $mainCharacter, Studio: $studio";
  }
}
