import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/bootstrap.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseNotifier().init();

  await bootstrap(() => const App());
}
