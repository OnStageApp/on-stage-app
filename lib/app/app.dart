import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_overlay.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(navigationNotifierProvider);
    final userSettings = ref.watch(userSettingsNotifierProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: userSettings.isDarkMode ?? false
          ? onStageDarkTheme
          : onStageLightTheme,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            child!,
            const ConnectivityOverlay(),
          ],
        );
      },
    );
  }
}
