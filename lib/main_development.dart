import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/app/firebase_test.dart';
import 'package:on_stage_app/bootstrap.dart';
import 'package:on_stage_app/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // For iOS, request permissions first.
  FirebaseMessaging.instance.requestPermission();

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Your logic to display a notification for foreground messages
    print("Message received in foreground: ${message.notification?.body}");
  });

  //get token
  String? token = await FirebaseMessaging.instance.getToken();
  print("Token: $token");
  FirebaseTestExample().setupNotifications();
  FirebaseTestExample().listenToFirebaseMessages();
  await bootstrap(() => const App());
}
