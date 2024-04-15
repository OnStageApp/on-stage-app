import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:on_stage_app/firebase_options.dart';
import 'package:on_stage_app/logger.dart';

class FirebaseNotifier {
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _showToken();
    await FirebaseMessaging.instance.requestPermission();
  }

  Future<void> _showToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    logger.i('Token: $token');
  }
}
