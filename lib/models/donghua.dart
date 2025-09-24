class Donghua {
  String _title;
  String _studio;
  int _year;
  String _imagePath;
  String _synopsis;

  Donghua(this._title, this._studio, this._year, this._imagePath, this._synopsis);

  // title
  String get title => _title;
  set title(String value) => _title = value;

  // studio
  String get studio => _studio;
  set studio(String value) => _studio = value;

  // year
  int get year => _year;
  set year(int value) => _year = value;

  // imagePath
  String get imagePath => _imagePath;
  set imagePath(String value) => _imagePath = value;

  // synopsis
  String get synopsis => _synopsis;
  set synopsis(String value) => _synopsis = value;

  String getInfo() => "$title ($year) - Studio: $studio";
}
