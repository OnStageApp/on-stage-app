import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {
    var text = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final isDeleting =
        newValue.selection.baseOffset < oldValue.selection.baseOffset;

    if (isDeleting && oldValue.text.endsWith('/')) {
      text = text.substring(0, text.length - 1);
    }

    if (text.length >= 4) {
      final year = int.tryParse(text.substring(0, 4)) ?? 0;
      if (year < DateTime.now().year) {
        return oldValue;
      }
      text =
          '${text.substring(0, 4)}${text.length > 4 ? '/${text.substring(4)}' : ''}';
    }

    if (text.length >= 7) {
      final month = int.tryParse(text.substring(5, 7)) ?? 0;
      if (month < 1 ||
          month > 12 ||
          (month < DateTime.now().month &&
              text.length == 7 &&
              int.parse(text.substring(0, 4)) == DateTime.now().year)) {
        return oldValue;
      }
      text =
          '${text.substring(0, 7)}${text.length > 7 ? '/${text.substring(7)}' : ''}';
    }

    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    if (text.length == 10) {
      final day = int.tryParse(text.substring(8)) ?? 0;
      if (day < 1 ||
          day > 31 ||
          (day < DateTime.now().day &&
              int.parse(text.substring(0, 4)) == DateTime.now().year &&
              int.parse(text.substring(5, 7)) == DateTime.now().month)) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {
    var text = newValue.text;
    final oldText = oldValue.text;

    // Remove any non-digit character
    text = text.replaceAll(RegExp('[^0-9]'), '');

    // Determine if we are deleting or inserting
    final isDeleting =
        newValue.selection.baseOffset < oldValue.selection.baseOffset;

    // Handle deletion
    if (isDeleting &&
        oldText.isNotEmpty &&
        oldText.endsWith(':') &&
        text.length < oldText.length - 1) {
      text = text.substring(0, text.length - 1);
    }

    // Format the text as HH:MM
    if (text.length >= 2) {
      final hour = int.tryParse(text.substring(0, 2));
      if (hour == null || hour < 0 || hour > 23) {
        return oldValue; // Invalid hour, return old value
      }
      text = text.substring(0, 2) +
          (text.length > 2 ? ':${text.substring(2)}' : '');
    }
    if (text.length > 5) {
      text = text.substring(0, 5); // Limit to 5 characters: HH:MM
    }

    // Ensure the cursor is at the correct position
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
