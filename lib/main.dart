import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/bootstrap.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_test_51Q9wEm00OekLPJYVKmp77mJyvOmVmJs9JKvTkICB7Q7xHfGQo8fvw1fUCRIXwQ20dScdIOUn5aGWZlD6GoUloXJi00IfGqsTHm';

  // await FirebaseNotifier().init();

  await bootstrap(() => const App());
}
