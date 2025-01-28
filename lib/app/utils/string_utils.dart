import 'package:flutter/material.dart';

extension TextUtilsStringExtension on String? {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullEmptyOrWhitespace =>
      this == null || this!.isEmpty || this!.trim().isEmpty;

  bool get isNotNullEmptyOrWhitespace => !isNullEmptyOrWhitespace;

  /// Removes diacritics (accent marks) from the string.
  String get removeDiacritics {
    if (this == null) return '';
    if (this!.isEmpty) return this!;

    const diacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽžȚțȘș';
    const nonDiacritics =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZzTtSs';

    final output = StringBuffer();
    for (final char in this!.characters) {
      final index = diacritics.indexOf(char);
      if (index >= 0) {
        output.write(nonDiacritics[index]);
      } else {
        output.write(char);
      }
    }

    return output.toString();
  }
}
