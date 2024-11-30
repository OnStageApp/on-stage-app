import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/application/token_manager.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/app_launcher_checker.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:upgrader/upgrader.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    _logoutUserOnReinstall();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unawaited(ref.read(analyticsServiceProvider.notifier).logAppOpen());
    });
    super.initState();
  }

  Future<void> _logoutUserOnReinstall() async {
    final accessToken =
        await TokenManager(const FlutterSecureStorage()).getAccessToken();
    final isFirstLaunch = await AppLaunchChecker.isFirstLaunch();
    if (isFirstLaunch && accessToken != null) {
      logger.i('First launch and user is logged in. Signing out');
      await ref.read(loginNotifierProvider.notifier).signOut();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(navigationNotifierProvider);
    final userSettings = ref.watch(userSettingsNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: userSettings.isDarkMode ?? false
          ? getOnStageDarkTheme(context)
          : getOnStageLightTheme(context),
      builder: (context, child) {
        return UpgradeAlert(
          navigatorKey: router.routerDelegate.navigatorKey,
          showIgnore: false,
          showLater: false,
          showReleaseNotes: false,
          child: child ?? const Text('child'),
        );
      },
    );
  }
}
