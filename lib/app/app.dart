import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_overlay.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';

final GetIt getIt = GetIt.instance;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: themeState.theme,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
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
