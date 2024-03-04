import 'package:flutter/material.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/bootstrap.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FirebaseNotifier().init();

  await bootstrap(() => const App());
  // FlutterNativeSplash.remove();
}
