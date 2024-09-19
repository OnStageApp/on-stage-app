import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:on_stage_app/app/shared/router_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_notifier.g.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.i('Background message: ${message.messageId}');
}

@riverpod
class FirebaseNotifier extends _$FirebaseNotifier {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? _pendingRoute;

  @override
  Future<void> build() async {
    await _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.requestPermission();
    await _setupLocalNotifications();
    final token = await FirebaseMessaging.instance.getToken();
    logger.i('FCM Device Token: $token');
    _handleMessages();
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) =>
          _handleNotificationResponse(response.payload),
    );
  }

  void _handleMessages() {
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) =>
          _handleNotificationResponse(message.data['screen'] as String?),
    );
  }

  void _handleNotificationResponse(String? screenName) {
    if (screenName != null) {
      _pendingRoute = screenName;
      _processNavigation();
    }
  }

  void _processNavigation() {
    if (_pendingRoute == null) return;

    ref.read(navigationNotifierProvider).go('$_pendingRoute');
    _pendingRoute = null;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails =
        AndroidNotificationDetails('channel_id', 'channel_name');
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data['screen'] as String?,
    );
  }

  void onAppReady() => _processNavigation();
}
