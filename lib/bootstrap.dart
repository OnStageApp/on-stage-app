import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/utils/environment_manager.dart';
import 'package:on_stage_app/app/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await EnvironmentManager.initialize();

  if (EnvironmentManager.isProduction && !kDebugMode) {
    await SentryFlutter.init(
      (options) {
        options
          ..debug = false
          ..enableAutoSessionTracking = !kDebugMode
          ..dsn = dotenv.env['SENTRY_DSN']
          ..tracesSampleRate = 1.0
          ..profilesSampleRate = 1.0;
      },
      appRunner: () async {
        await _runApp(builder);
      },
    );
  } else {
    await _runApp(builder);
  }
}

Future<void> _runApp(
  FutureOr<Widget> Function() builder,
) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: await builder(),
    ),
  );
}
