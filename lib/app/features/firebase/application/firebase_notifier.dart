import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_state.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_notifier.g.dart';

@Riverpod(keepAlive: true)
class FirebaseNotifier extends _$FirebaseNotifier {
  FirebaseState build() {
    return FirebaseState();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((token) {
      print("token is $token");
    });

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.i('Initialize firebase messaging');
  }
}
