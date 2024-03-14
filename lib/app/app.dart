import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

final GetIt getIt = GetIt.instance;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends ConsumerState<App> {
  @override
  void initState() {
    //ref.read(firebaseNotifierProvider.notifier).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: onStageLightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
