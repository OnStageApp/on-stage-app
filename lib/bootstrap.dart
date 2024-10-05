import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            'https://92392bd67d0cd10db9198972943a3ef6@o4508048789602304.ingest.de.sentry.io/4508048794320976'
        ..tracesSampleRate = 1.0
        ..profilesSampleRate = 1.0;
    },
    appRunner: () async {
      //TODO: Uncomment when we need sentry
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   Sentry.captureException(
      //     details.exception,
      //     stackTrace: details.stack,
      //   );
      //   log(
      //     details.exceptionAsString(),
      //     stackTrace: details.stack,
      //   );
      // };

      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: await builder(),
        ),
      );
    },
  );
}
