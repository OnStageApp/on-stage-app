import 'package:flutter/services.dart';

class ChordDeletionInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only handle single character deletions
    if (!_isSingleCharacterDeletion(oldValue, newValue)) {
      return newValue;
    }

    final deletionIndex = _findDeletionIndex(oldValue.text, newValue.text);
    if (deletionIndex == -1) return newValue;

    // If deleting a bracket directly, perform normal deletion
    if (oldValue.text[deletionIndex] == '[') return newValue;

    // Find chord boundaries if we're inside a chord
    final chordBoundaries = _findChordBoundaries(oldValue.text, deletionIndex);
    if (chordBoundaries == null) return newValue;

    // Delete the entire chord
    return _deleteChord(oldValue.text, chordBoundaries);
  }

  bool _isSingleCharacterDeletion(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return oldValue.text.length - newValue.text.length == 1;
  }

  int _findDeletionIndex(String oldText, String newText) {
    for (var i = 0; i < oldText.length; i++) {
      if (i >= newText.length || oldText[i] != newText[i]) {
        return i;
      }
    }
    return -1;
  }

  ({int start, int end})? _findChordBoundaries(String text, int deletionIndex) {
    // Find opening bracket
    int? openIndex;
    for (var i = deletionIndex; i >= 0; i--) {
      if (text[i] == '[' && _isBalancedUpTo(text, i)) {
        openIndex = i;
        break;
      }
    }
    if (openIndex == null) return null;

    // Find closing bracket
    var bracketCount = 1;
    for (var i = openIndex + 1; i < text.length; i++) {
      if (text[i] == '[') bracketCount++;
      if (text[i] == ']') {
        bracketCount--;
        if (bracketCount == 0) {
          // Verify deletion is within chord boundaries
          if (deletionIndex >= openIndex && deletionIndex <= i) {
            return (start: openIndex, end: i);
          }
          break;
        }
      }
    }
    return null;
  }

  bool _isBalancedUpTo(String text, int index) {
    var openCount = 0;
    var closeCount = 0;

    for (var i = 0; i <= index; i++) {
      if (text[i] == '[') openCount++;
      if (text[i] == ']') closeCount++;
    }

    return openCount > closeCount;
  }

  TextEditingValue _deleteChord(
    String text,
    ({int start, int end}) boundaries,
  ) {
    return TextEditingValue(
      text: text.substring(0, boundaries.start) +
          text.substring(boundaries.end + 1),
      selection: TextSelection.collapsed(offset: boundaries.start),
    );
  }
}
