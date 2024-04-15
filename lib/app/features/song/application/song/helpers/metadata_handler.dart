class MetadataHandler {
  /// As specifications says "meta data is specified using “tags” surrounded by { and } characters"
  final RegExp regMetadata = RegExp(r'^ *\{.*}');
  final RegExp regCapo = RegExp(r'^\{capo:.*[0-9]+\}');
  final RegExp regArtist = RegExp(r'^\{artist:.*\}');
  final RegExp regTitle = RegExp(r'^\{title:.*\}');
  final RegExp regKey = RegExp(r'^\{key:.*\}');
  int? capo;
  String? artist;
  String? title;
  String? key;

  /// Try to find and parse metadata in the string.
  /// Return true if there was a match
  bool parseLine(String line) {
    return _setCapoIfMatch(line) ||
        _setArtistIfMatch(line) ||
        _setKeyIfMatch(line) ||
        _setTitleIfMatch(line);
  }

  /// Get key in line if it's present
  /// Return true if match was found
  bool _setKeyIfMatch(String line) {
    final tmpKey =
        regKey.hasMatch(line) ? _getMetadataFromLine(line, 'key:') : null;
    key ??= tmpKey;
    return tmpKey != null;
  }

  /// Get capo in line if it's present
  /// Return true if match was found
  bool _setCapoIfMatch(String line) {
    final tmpCapo = regCapo.hasMatch(line)
        ? int.parse(_getMetadataFromLine(line, 'capo:'))
        : null;
    capo ??= tmpCapo;
    return tmpCapo != null;
  }

  /// Get artist in line if it's present
  /// Return true if match was found
  bool _setArtistIfMatch(String line) {
    final tmpArtist =
        regArtist.hasMatch(line) ? _getMetadataFromLine(line, 'artist:') : null;
    artist ??= tmpArtist;
    return tmpArtist != null;
  }

  /// Get title in line if it's present
  /// Return true if match was found
  bool _setTitleIfMatch(String line) {
    final tmpTitle =
        regTitle.hasMatch(line) ? _getMetadataFromLine(line, 'title:') : null;
    title ??= tmpTitle;
    return tmpTitle != null;
  }

  String _getMetadataFromLine(String line, String key) {
    return line.split(key).last.split('}').first.trim();
  }
}
