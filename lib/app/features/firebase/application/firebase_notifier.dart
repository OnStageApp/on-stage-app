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
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission();

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _showToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    logger.i('DEVICE TOKEN: $token');
  }

  void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
