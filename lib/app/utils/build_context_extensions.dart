import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.of(this).size;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

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

extension ScreenExtension on BuildContext {
  bool get isLargeScreen => MediaQuery.of(this).size.width > 1000;
}
