import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class WidgetUtils {
  static InputDecoration getDecorations(BuildContext context, IconData? icon,
      {String? hintText,}) {
    return InputDecoration(
      isDense: true,
      fillColor: context.colorScheme.onSurfaceVariant,
      filled: true,
      hintText: hintText,
      hintStyle: context.textTheme.titleMedium!.copyWith(
        color: context.colorScheme.outline,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(Insets.small),
        ),
      ),
    );
  }

  static TextStyle LYRICS_DEFAULT_STYLE = const TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    color: Colors.black,
  );
  static TextStyle CHORDS_DEFAULT_STYLE = const TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}
