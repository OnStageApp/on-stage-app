import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(analyticsServiceProvider.notifier).logAppOpen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            // const ConnectivityOverlay(),
          ],
        );
      },
    );
  }
}
