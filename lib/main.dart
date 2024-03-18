import 'package:flutter/material.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/bootstrap.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await FirebaseNotifier().init();

  await bootstrap(() => const App());
}
