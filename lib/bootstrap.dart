import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:on_stage_app/app/router/app_router.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  final getIt = GetIt.instance;

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  getIt.registerSingleton(AppRouter.router);

  runApp(ProviderScope(child: await builder()));
}
