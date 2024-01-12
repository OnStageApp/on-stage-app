class JsonPatchUtils {
  static Map<String, dynamic> replace(String path, dynamic value) {
    return {
      'op': 'replace',
      'path': path,
      'value': value,
    };
  }

  // create a list of patches
  static List<Map<String, dynamic>> replaceMultiple(
    Map<String, dynamic> newMap,
    String path,
  ) {
    return newMap.entries.map((entry) {
      return replace(
        '$path/${entry.key}',
        entry.value,
      );
    }).toList();
  }
}
