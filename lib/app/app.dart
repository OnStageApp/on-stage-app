import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_overlay.dart';
import 'package:on_stage_app/app/shared/router_notifier.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final router = ref.watch(navigationNotifierProvider);
    print('ISLOGGED IN:${ref.watch(loginNotifierProvider).isLoggedIn}');
    return MaterialApp.router(
      routerConfig: router,
      theme: themeState.theme,
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
