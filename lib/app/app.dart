import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_overlay.dart';
import 'package:on_stage_app/app/shared/router_notifier.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    ref.read(firebaseNotifierProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(firebaseNotifierProvider.notifier).onAppReady();
  }

  @override
  Widget build(BuildContext context) {
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
