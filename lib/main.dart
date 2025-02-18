import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/bootstrap.dart';
import 'package:on_stage_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _initAudioBackground();

  await dotenv.load();

  await bootstrap(() => const App());
}

Future<void> _initAudioBackground() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.onstage.app.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
    // Optionally, set fast forward / rewind intervals:
    fastForwardInterval: const Duration(seconds: 15),
    rewindInterval: const Duration(seconds: 15),
  );
}
