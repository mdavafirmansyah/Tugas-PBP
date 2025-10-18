class AnimasiSeries {
  String _title;
  String _studio;
  int _year;
  String _imagePath;
  String _synopsis;
  List<String> _genres;
  String _trailerUrl;

  AnimasiSeries(
    this._title,
    this._studio,
    this._year,
    this._imagePath,
    this._synopsis,
    this._genres,
    this._trailerUrl,
  );

  // Getters and Setters
  String get title => _title;
  set title(String value) => _title = value;

  String get studio => _studio;
  set studio(String value) => _studio = value;

  int get year => _year;
  set year(int value) => _year = value;

  String get imagePath => _imagePath;
  set imagePath(String value) => _imagePath = value;

  String get synopsis => _synopsis;
  set synopsis(String value) => _synopsis = value;

  List<String> get genres => _genres;
  set genres(List<String> value) => _genres = value;

  String get trailerUrl => _trailerUrl;
  set trailerUrl(String value) => _trailerUrl = value;

  // Metode dasar yang bisa di-override oleh subclass
  String getInfo() => "$title ($year) - Studio: $studio";
}
