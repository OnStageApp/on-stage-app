import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:force_update_helper/force_update_helper.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/application/token_manager.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/remote_configs/remote_config_service.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/app_launcher_checker.dart';
import 'package:on_stage_app/app/utils/dialog_helper.dart';
import 'package:on_stage_app/app/utils/environment_manager.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';
import 'package:on_stage_app/app/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:on_stage_app/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    _logoutUserOnReinstall();
    ref.read(remoteConfigProvider).initialize();
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
    ref.watch(firebaseNotifierProvider.notifier);
    final router = ref.watch(navigationNotifierProvider);
    final userSettings = ref.watch(userSettingsNotifierProvider);
    final remoteConfig = ref.watch(remoteConfigProvider);
    final isDarkModeCache =
        ref.read(sharedPreferencesProvider).getBool('isDarkMode');

    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvironmentManager.isProduction,
      routerConfig: router,
      theme: userSettings.isDarkMode ?? isDarkModeCache ?? false
          ? getOnStageDarkTheme(context)
          : getOnStageLightTheme(context),
      builder: (context, child) {
        return _buildChildWithForceUpdate(router, remoteConfig, child);
      },
    );
  }

  Widget _buildChildWithForceUpdate(
    GoRouter router,
    RemoteConfigService remoteConfig,
    Widget? child,
  ) {
    return ForceUpdateWidget(
      navigatorKey: router.routerDelegate.navigatorKey,
      forceUpdateClient: ForceUpdateClient(
        fetchRequiredVersion: () async {
          return remoteConfig.minRequiredVersion;
        },
        iosAppStoreId: dotenv.get('APPLE_APP_ID'),
      ),
      allowCancel: false,
      showForceUpdateAlert: (context, allowCancel) =>
          DialogHelper.showPlatformDialog(
        context: context,
        title: const Text('Update Required'),
        content: const Text(
          'A new version of the app is available.'
          ' Please update to continue using the app.',
        ),
        confirmText: 'Update Now',
        isDestructive: true,
      ),
      showStoreListing: (storeUrl) async {
        if (await canLaunchUrl(storeUrl)) {
          await launchUrl(
            storeUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          logger.i('Cannot launch URL: $storeUrl');
        }
      },
      onException: (e, st) {
        logger.e(e.toString());
      },
      child: child ?? const Text('child'),
    );
  }
}
