import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  // AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void popDialog<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}

extension ObjectExt<T> on T? {
  R? let<R>(R Function(T) block) => this != null ? block(this as T) : null;
}
