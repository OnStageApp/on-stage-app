import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class WidgetUtils {
  static InputDecoration getDecorations(IconData icon) {
    return InputDecoration(
      isDense: true,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Insets.small),
        ),
      ),
    );
  }
}
