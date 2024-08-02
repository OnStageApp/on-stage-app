import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var oldText = oldValue.text;

    // Remove any non-digit character
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Determine if we are deleting or inserting
    bool isDeleting =
        newValue.selection.baseOffset < oldValue.selection.baseOffset;

    // Handle deletion
    if (isDeleting && oldText.length > 0 && oldText.endsWith('/')) {
      text = text.substring(0, text.length - 1);
    }

    // Format the text as DD/MM/YYYY
    if (text.length >= 2) {
      var day = int.tryParse(text.substring(0, 2));
      if (day == null || day < 1 || day > 31) {
        return oldValue; // Invalid day, return old value
      }
      text = text.substring(0, 2) +
          (text.length > 2 ? '/' + text.substring(2) : '');
    }
    if (text.length >= 5) {
      var month = int.tryParse(text.substring(3, 5));
      if (month == null || month < 1 || month > 12) {
        return oldValue; // Invalid month, return old value
      }
      text = text.substring(0, 5) +
          (text.length > 5 ? '/' + text.substring(5) : '');
    }
    if (text.length > 10) {
      text = text.substring(0, 10); // Limit to 10 characters: DD/MM/YYYY
    }

    // Ensure the cursor is at the correct position
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var oldText = oldValue.text;

    // Remove any non-digit character
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Determine if we are deleting or inserting
    bool isDeleting =
        newValue.selection.baseOffset < oldValue.selection.baseOffset;

    // Handle deletion
    if (isDeleting &&
        oldText.length > 0 &&
        oldText.endsWith(':') &&
        text.length < oldText.length - 1) {
      text = text.substring(0, text.length - 1);
    }

    // Format the text as HH:MM
    if (text.length >= 2) {
      var hour = int.tryParse(text.substring(0, 2));
      if (hour == null || hour < 0 || hour > 23) {
        return oldValue; // Invalid hour, return old value
      }
      text = text.substring(0, 2) +
          (text.length > 2 ? ':' + text.substring(2) : '');
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
