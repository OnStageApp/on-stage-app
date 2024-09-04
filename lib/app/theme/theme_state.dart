import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class ThemeState {
  ThemeState(this.theme);

  final ThemeData theme;
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(onStageLightTheme));

  void toggleTheme() {
    state = state.theme == onStageLightTheme
        ? ThemeState(onStageDarkTheme)
        : ThemeState(onStageLightTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
